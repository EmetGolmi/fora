class ExecutiveOrdersController < ApplicationController
  def show
    slug = params[:id]

    Person.where.not(executive_orders: nil).find_each do |person|
      eo = (person.executive_orders || []).find { |e| e["slug"] == slug }
      if eo
        @person = person
        @eo = eo
        break
      end
    end

    if @eo.nil?
      render file: "public/404.html", status: :not_found, layout: false
      return
    end

    cached = Rails.cache.read("eo_summary:#{slug}")
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
        model:      "claude-haiku-4-5-20251001",
        max_tokens: 500,
        system:     "You are a nonpartisan civic information assistant for FORA, a Philadelphia civic platform. Explain executive orders in plain language for everyday citizens. Be concise, clear, and never use jargon. Never predict outcomes as certain. Always use 'may', 'could', or 'might' when discussing possible effects. Never take political sides. Never use markdown formatting, bullet points, bold text, asterisks, or section labels in your response.",
        messages: [
          {
            role:    "user",
            content: "For this executive order: '#{@eo['title']}' (#{@eo['number']}, signed #{@eo['date']}, category: #{@eo['category']}) — respond with exactly two paragraphs separated by the exact string ' || ' (space pipe pipe space). First paragraph: what this executive order does in 2-3 plain sentences. Second paragraph: 2-3 sentences about who is affected and how, using may/could/might. Do not use any headers, labels, bullet points, or markdown. Example format: This order directs X. It also does Y. || This may affect people by Z. It could also lead to W."
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
          "eo_summary:#{params[:id]}",
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
      .gsub(/\*\*[^*]+\*\*:\s*/, '')
      .gsub(/\*\*([^*]+)\*\*/, '\1')
      .gsub(/\*([^*]+)\*/, '\1')
      .gsub(/(?:^|\n)\s*[-*]\s+/, ' ')
      .squeeze(' ')
      .strip
      .presence
  end
end
