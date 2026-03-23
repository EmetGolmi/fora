class BillsController < ApplicationController
  def show
    @bill = CivicBill.find_by(id: params[:id])
    if @bill.nil?
      render file: "public/404.html", status: :not_found, layout: false
      return
    end

    cached = Rails.cache.read("bill_summary:#{@bill.id}")
    if cached.present?
      data     = JSON.parse(cached, symbolize_names: true)
      @summary = data[:summary]
      @effects = data[:effects]
    else
      fetch_ai_summary
    end
  end

  private

  def fetch_ai_summary
    response = HTTParty.post(
      "https://api.anthropic.com/v1/messages",
      headers: {
        "x-api-key"         => ENV["ANTHROPIC_API_KEY"],
        "anthropic-version" => "2023-06-01",
        "content-type"      => "application/json"
      },
      body: {
        model:      "claude-sonnet-4-5",
        max_tokens: 500,
        system:     "You are a nonpartisan civic information assistant for FORA, a Philadelphia civic platform. Explain legislation in plain language for everyday citizens. Be concise, clear, and never use jargon. Never predict outcomes as certain. Always use 'may', 'could', or 'might' when discussing possible effects. Never take political sides. Never use markdown formatting, bullet points, bold text, asterisks, or section labels in your response.",
        messages: [
          {
            role:    "user",
            content: "For this legislation: '#{@bill.title}' (Status: #{@bill.status}) — respond with exactly two paragraphs separated by the exact string ' || ' (space pipe pipe space). First paragraph: what this bill does in 2-3 plain sentences. Second paragraph: 2-3 sentences about possible effects using may/could/might. Do not use any headers, labels, bullet points, or markdown. Example format: This bill does X. It also does Y. || This may affect people by Z. It could also lead to W."
          }
        ]
      }.to_json
    )

    if response.success?
      text     = response.parsed_response.dig("content", 0, "text").to_s
      parts    = text.split(" || ", 2).map(&:strip)
      @summary = clean_text(parts[0])
      @effects = clean_text(parts[1])
      if @summary || @effects
        Rails.cache.write(
          "bill_summary:#{@bill.id}",
          { summary: @summary, effects: @effects }.to_json,
          expires_in: 24.hours
        )
      end
    end
  rescue StandardError
    @summary = nil
    @effects = nil
  end

  def clean_text(text)
    return nil if text.blank?
    text
      .gsub(/\*\*[^*]+\*\*:\s*/, '')   # strip **Label:** section headers entirely
      .gsub(/\*\*([^*]+)\*\*/, '\1')   # strip remaining **bold** leaving text
      .gsub(/\*([^*]+)\*/, '\1')       # strip *italic* leaving text
      .gsub(/(?:^|\n)\s*[-*]\s+/, ' ') # strip bullet markers, join to prose
      .squeeze(' ')
      .strip
      .presence
  end
end
