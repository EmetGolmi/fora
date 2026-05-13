module ApplicationHelper
  # Renders a clickable phone number: <a href="tel:..." class="phone-link">label</a>
  # number: digits only or formatted (non-digits stripped for href)
  # label:  optional display string; defaults to number as passed
  def phone_link(number, label = nil)
    href    = "tel:#{number.to_s.gsub(/\D/, '')}"
    display = label || number.to_s
    link_to display, href, class: "phone-link"
  end

  # Renders a tappable address that opens an Apple / Google / Waze picker.
  # address:      query string sent to all three map services
  # display_text: visible text (defaults to address)
  # Requires toggleMap(el, event) defined in the page's script block.
  def address_link(address, display_text: nil)
    enc        = CGI.escape(address.to_s)
    apple_url  = "https://maps.apple.com/?address=#{enc}"
    google_url = "https://www.google.com/maps/search/?api=1&query=#{enc}"
    waze_url   = "https://www.waze.com/ul?q=#{enc}"
    display    = display_text || address

    content_tag(:span, class: "address-wrap", onclick: "toggleMap(this,event)") do
      safe_join([
        content_tag(:span, display, class: "address-link"),
        content_tag(:span, class: "map-menu") {
          safe_join([
            link_to(safe_join([content_tag(:span, "📍", class: "map-menu-icon"), "Apple Maps"]),
                    apple_url, target: "_blank", rel: "noopener"),
            link_to(safe_join([content_tag(:span, "🌐", class: "map-menu-icon"), "Google Maps"]),
                    google_url, target: "_blank", rel: "noopener"),
            link_to(safe_join([content_tag(:span, "🚗", class: "map-menu-icon"), "Waze"]),
                    waze_url, target: "_blank", rel: "noopener")
          ])
        }
      ])
    end
  end

  OFFICIAL_SLUG_PATHS = {
    "F000479" => "/officials/usa/pa/jfetterman",
    "M001243" => "/officials/usa/pa/dmccormick",
    "E000296" => "/officials/usa/pa/devans",
    "nsaval"  => "/officials/usa/pa/nsaval",
    "bwaxman" => "/officials/usa/pa/bwaxman"
  }.freeze

  def official_url_for(bioguide_id)
    OFFICIAL_SLUG_PATHS[bioguide_id] || official_path(bioguide_id)
  end

  def fora_share_btn(data_attrs = {}, color: "rgba(255,255,255,0.45)", stop_propagation: false)
    data_json = data_attrs.to_json.gsub("'", "&#39;")
    js = stop_propagation ? "event.stopPropagation();foraShare({...#{data_json}, _btn: this})" : "foraShare({...#{data_json}, _btn: this})"
    content_tag(:button,
      raw('<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>'),
      onclick: js,
      title: "Share this",
      style: "background:none;border:none;cursor:pointer;padding:4px;line-height:0;color:#{color};flex-shrink:0;opacity:0.7;",
      onmouseover: "this.style.opacity='1'",
      onmouseout:  "this.style.opacity='0.7'"
    )
  end
end
