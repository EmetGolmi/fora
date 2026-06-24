namespace :bills do
  # ── rake bills:seed_summaries ─────────────────────────────────────────────
  # Generates plain_summary + effects (JSONB array) for every active bill
  # that's missing a plain_summary.  Uses Claude Haiku for speed / cost.
  #
  # Usage:
  #   rails bills:seed_summaries
  #   rails bills:seed_summaries BILL_IDS=6,8,9   # specific bills
  #   rails bills:seed_summaries DRY_RUN=1         # print prompts, don't save
  desc "Seed plain_summary + effects for active bills missing them"
  task seed_summaries: :environment do
    require "net/http"
    require "json"

    dry_run   = ENV["DRY_RUN"].present?
    bill_ids  = ENV["BILL_IDS"]&.split(",")&.map(&:to_i)

    scope = CivicBill.active.where(plain_summary: [nil, ""])
    scope = scope.where(id: bill_ids) if bill_ids.present?

    bills = scope.order(:id).to_a
    puts "Seeding summaries for #{bills.size} bill(s)#{dry_run ? ' [DRY RUN]' : ''}..."
    puts

    ok = 0; err = 0

    bills.each_with_index do |bill, i|
      label = "#{bill.identifier.presence || "Bill #{bill.id}"} (#{bill.jurisdiction})"
      puts "[#{i+1}/#{bills.size}] #{label}"
      puts "  #{bill.title.truncate(90)}"

      context = build_bill_context(bill)

      if dry_run
        puts "  PROMPT CONTEXT: #{context.truncate(200)}"
        puts
        next
      end

      begin
        summary, effects = call_ai(context)

        if summary.present?
          effects_arr = parse_effects(effects)
          bill.update_columns(
            plain_summary: summary,
            effects:       effects_arr
          )
          puts "  ✓ saved (#{summary.length} chars, #{effects_arr.size} effects)"
          ok += 1
        else
          puts "  ✗ no summary returned"
          err += 1
        end
      rescue => e
        puts "  ✗ ERROR: #{e.message}"
        err += 1
      end

      sleep 0.4   # gentle rate-limiting
      puts
    end

    puts "Done — #{ok} saved, #{err} errors."
  end

  # ── rake bills:seed_sit_study ─────────────────────────────────────────────
  # Fills sit_for, sit_against, and study_facts for bills that have a
  # plain_summary but lack guide content (guide_seeded == false).
  #
  # Usage:
  #   rails bills:seed_sit_study
  #   rails bills:seed_sit_study BILL_IDS=6,8,9
  desc "Seed sit_for / sit_against / study_facts for active bills"
  task seed_sit_study: :environment do
    require "net/http"
    require "json"

    dry_run  = ENV["DRY_RUN"].present?
    bill_ids = ENV["BILL_IDS"]&.split(",")&.map(&:to_i)

    scope = CivicBill.active
                     .where.not(plain_summary: [nil, ""])
                     .where(guide_seeded: false)
    scope = scope.where(id: bill_ids) if bill_ids.present?

    bills = scope.order(:id).to_a
    puts "Seeding Sit/Study for #{bills.size} bill(s)#{dry_run ? ' [DRY RUN]' : ''}..."
    puts

    ok = 0; err = 0

    bills.each_with_index do |bill, i|
      label = "#{bill.identifier.presence || "Bill #{bill.id}"} (#{bill.jurisdiction})"
      puts "[#{i+1}/#{bills.size}] #{label}"

      context = build_bill_context(bill)
      context += "\nPlain summary: #{bill.plain_summary}" if bill.plain_summary.present?

      if dry_run
        puts "  DRY RUN — skipping"
        puts
        next
      end

      begin
        sit_for, sit_against, facts = call_ai_guide(context)

        if sit_for.present? && sit_against.present?
          bill.update_columns(
            sit_for:      sit_for,
            sit_against:  sit_against,
            study_facts:  facts,
            guide_seeded: true
          )
          puts "  ✓ saved guide (#{facts.size} facts)"
          ok += 1
        else
          puts "  ✗ incomplete guide returned"
          err += 1
        end
      rescue => e
        puts "  ✗ ERROR: #{e.message}"
        err += 1
      end

      sleep 0.5
      puts
    end

    puts "Done — #{ok} saved, #{err} errors."
  end

  # ─────────────────────────────────────────────────────────────────────────
  private

  def build_bill_context(bill)
    parts = []
    parts << "Bill: #{bill.identifier} (#{bill.jurisdiction})"
    parts << "Title: #{bill.title}"
    parts << "Status: #{bill.status}" if bill.status.present?

    if bill.sponsors.present?
      names = Array(bill.sponsors).filter_map { |s| s["name"] || s[:name] }
      parts << "Sponsors: #{names.join(', ')}" if names.any?
    end

    if bill.summary.present?
      parts << "Legislative summary: #{bill.summary}"
    end

    if bill.raw_data.present?
      raw = bill.raw_data.is_a?(String) ? JSON.parse(bill.raw_data) : bill.raw_data
      abs = raw.dig("abstracts", 0, "abstract") ||
            raw.dig("abstract") ||
            raw.dig("description")
      parts << "Abstract: #{abs}" if abs.present?
    end

    parts.join("\n")
  end

  # ── AI call: plain_summary + effects ─────────────────────────────────────
  def call_ai(context)
    body = {
      model:      "claude-haiku-4-5-20251001",
      max_tokens: 600,
      system:     "You are a nonpartisan civic information assistant for FORA, a Philadelphia civic platform. Explain legislation in plain language for everyday citizens. Be concise and clear. Never use jargon. Always use 'may', 'could', or 'might' for effects. Never take political sides. No markdown, bullets, bold, asterisks, or section labels.",
      messages: [
        {
          role:    "user",
          content: <<~PROMPT
            For this legislation:
            #{context}

            Respond in exactly this format — no other text:
            SUMMARY_SENTENCE_1. SUMMARY_SENTENCE_2. || EFFECT_1 | EFFECT_2 | EFFECT_3

            Rules:
            - Before || : 2-3 plain sentences saying what the bill does.
            - After || : exactly 3 effects separated by | (pipe), each 1 sentence using may/could/might.
            - No markdown, no bullets, no headers.
          PROMPT
        }
      ]
    }

    resp = call_anthropic(body)
    text = resp.dig("content", 0, "text").to_s.strip
    parts = text.split(" || ", 2).map(&:strip)
    summary = clean_text(parts[0])
    effects = clean_text(parts[1])
    [summary, effects]
  end

  # ── AI call: sit_for / sit_against / study_facts ──────────────────────────
  def call_ai_guide(context)
    body = {
      model:      "claude-haiku-4-5-20251001",
      max_tokens: 900,
      system:     "You are a nonpartisan civic information assistant. Provide balanced, factual analysis. Never advocate. Represent both sides fairly. No markdown.",
      messages: [
        {
          role:    "user",
          content: <<~PROMPT
            For this legislation:
            #{context}

            Respond in exactly this format — no other text:
            FOR: 2-3 sentences making the strongest honest case for this bill. || AGAINST: 2-3 sentences making the strongest honest case against. || FACT: one fact sentence. SOURCE: source label | FACT: one fact sentence. SOURCE: source label | FACT: one fact sentence. SOURCE: source label

            Rules:
            - FOR and AGAINST must be balanced and honest.
            - Each FACT must be factual and verifiable. Source label is short (e.g. "NCSL", "CBO", "Bill text").
            - No markdown, no bullets, no headers. Separate the three sections with || exactly.
          PROMPT
        }
      ]
    }

    resp = call_anthropic(body)
    text = resp.dig("content", 0, "text").to_s.strip
    parts = text.split(" || ", 3).map(&:strip)

    sit_for     = clean_text(parts[0]&.sub(/\AFOR:\s*/i, ""))
    sit_against = clean_text(parts[1]&.sub(/\AAGAINST:\s*/i, ""))
    facts_raw   = clean_text(parts[2])

    facts = parse_guide_facts(facts_raw)
    [sit_for, sit_against, facts]
  end

  def call_anthropic(body)
    uri = URI("https://api.anthropic.com/v1/messages")
    req = Net::HTTP::Post.new(uri)
    req["x-api-key"]         = ENV.fetch("ANTHROPIC_API_KEY")
    req["anthropic-version"] = "2023-06-01"
    req["content-type"]      = "application/json"
    req.body = body.to_json

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |h| h.request(req) }
    raise "API error #{res.code}: #{res.body.first(200)}" unless res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)
  end

  def parse_effects(effects_str)
    return [] if effects_str.blank?
    effects_str.split("|").map { |e| clean_text(e) }.compact
  end

  def parse_guide_facts(facts_str)
    return [] if facts_str.blank?
    facts_str.split("|").filter_map do |chunk|
      chunk = chunk.strip
      m = chunk.match(/FACT:\s*(.+?)\.\s*SOURCE:\s*(.+)/i)
      next unless m
      { "text" => m[1].strip + ".", "source_label" => m[2].strip }
    end
  end

  def clean_text(text)
    return nil if text.blank?
    text
      .gsub(/\*\*[^*]+\*\*:\s*/, "")
      .gsub(/\*\*([^*]+)\*\*/, '\1')
      .gsub(/\*([^*]+)\*/, '\1')
      .gsub(/(?:^|\n)\s*[-*]\s+/, " ")
      .squeeze(" ")
      .strip
      .presence
  end
end
