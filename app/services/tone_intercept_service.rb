# ToneInterceptService — advisory-only tone check for bill comment drafts.
#
# CONTRACT (never violate):
#   - STATELESS: no result is stored anywhere. Each call is fire-and-forget.
#   - FAIL-OPEN: any error (API timeout, parse failure, etc.) returns
#     { flagged: false } so the user is never silently blocked.
#   - ADVISORY ONLY: flagged? true surfaces a correction slip with
#     "Revise" / "Post anyway" — the user always retains final control.
#   - NEVER flags: strong disagreement, passionate policy criticism, sarcasm,
#     blunt language, profanity alone, or any political viewpoint.
#   - DOES flag: personal attacks on named individuals, contempt / dehumanisation
#     directed at a group, calls for harm.
#
# Usage:
#   result = ToneInterceptService.check("Your draft text here")
#   result[:flagged]  # => true | false
#   result[:reason]   # => short explanation string (present only when flagged)
class ToneInterceptService
  MODEL   = "claude-haiku-4-5-20251001".freeze
  API_URL = "https://api.anthropic.com/v1/messages".freeze

  SYSTEM_PROMPT = <<~SYS.strip
    You are a civic-discourse tone reviewer. Your ONLY job is to flag text that
    contains one or more of the following:
      1. A personal attack on a named individual (not their policy).
      2. Contempt or dehumanisation directed at an ethnic, religious, or political group.
      3. An explicit call for violence or harm.

    You MUST NOT flag:
      - Strong, even harsh, disagreement with a policy or law.
      - Passionate or blunt language that criticises a policy.
      - Profanity that does not target a person or group.
      - Any political viewpoint, however extreme.
      - Sarcasm, frustration, or cynicism about government.

    Respond with EXACTLY one of:
      CLEAN
      FLAG: <one concise sentence explaining what was flagged, ≤ 20 words>

    No other output. No preamble. No apology. One line only.
  SYS

  # Returns { flagged: Boolean, reason: String? }
  def self.check(draft_text)
    new.check(draft_text)
  end

  def check(draft_text)
    return { flagged: false } if draft_text.blank?

    response = HTTParty.post(
      API_URL,
      headers: {
        "x-api-key"         => ENV["ANTHROPIC_API_KEY"],
        "anthropic-version" => "2023-06-01",
        "content-type"      => "application/json"
      },
      body: {
        model:      MODEL,
        max_tokens: 80,
        system:     SYSTEM_PROMPT,
        messages:   [{ role: "user", content: draft_text.to_s.truncate(2000) }]
      }.to_json,
      timeout: 8
    )

    return { flagged: false } unless response.success?

    parse(response.parsed_response.dig("content", 0, "text").to_s.strip)
  rescue => e
    Rails.logger.warn("ToneInterceptService: fail-open after error — #{e.class}: #{e.message}")
    { flagged: false }
  end

  private

  def parse(line)
    if line.upcase.start_with?("FLAG:")
      { flagged: true, reason: line.sub(/\AFLAG:\s*/i, "").strip }
    else
      { flagged: false }
    end
  end
end
