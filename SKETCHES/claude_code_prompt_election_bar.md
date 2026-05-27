# CLAUDE CODE PROMPT
# FORA · Election Day Banner · Dashboard Integration
# Target: fora.center/dashboard
# Date written: May 18, 2026
# ─────────────────────────────────────────────────────────

## TASK

Add a time-sensitive election alert bar to the FORA dashboard that appears
immediately below the top nav, spanning full width, for registered Philadelphia
voters on May 18 and May 19, 2026 only. When clicked, it routes to /votemay19.

---

## FILES TO TOUCH

1. app/views/layouts/application.html.erb  — inject the bar partial
2. app/views/shared/_election_bar.html.erb — create this partial (new file)
3. app/assets/stylesheets/election_bar.css — create this stylesheet (new file)
   OR add to app/assets/stylesheets/application.css if a single CSS file is preferred
4. config/routes.rb — add the /votemay19 route
5. app/controllers/vote_controller.rb — create if it doesn't exist
6. app/views/vote/may19.html.erb — placeholder (we will populate this separately)

---

## STEP 1 — Route

In config/routes.rb, add:

  get '/votemay19', to: 'vote#may19', as: 'votemay19'

---

## STEP 2 — Controller

Create app/controllers/vote_controller.rb (or add to existing):

  class VoteController < ApplicationController
    def may19
      # Address lookup will be wired here after MVP
      # For now, renders the static vote guide
      render 'vote/may19'
    end
  end

---

## STEP 3 — View placeholder

Create app/views/vote/may19.html.erb as an empty file for now.
We will populate it with the full vote guide in the next step.
For now just put: <p>Vote guide loading...</p>

---

## STEP 4 — The election bar partial

Create app/views/shared/_election_bar.html.erb with this content exactly:

─────────────────────────────────────────────────────────
<% election_day   = Date.new(2026, 5, 19) %>
<% show_bar_from  = Date.new(2026, 5, 18) %>   <%# show today AND election day %>
<% show_bar_until = Date.new(2026, 5, 19) %>

<% if Date.today >= show_bar_from && Date.today <= show_bar_until %>
  <%
    is_today = Date.today == election_day
    verb     = is_today ? "Today is Election Day" : "Vote Tomorrow, May 19"
    cta      = is_today ? "Polls open 7 AM – 8 PM · Click to see your ballot & cast a mock-vote" \
                        : "Pennsylvania Primary · Philadelphia · Click to learn more & cast a mock-ballot"
  %>

  <a href="<%= votemay19_path %>" class="fora-election-bar" id="fora-election-bar">
    <div class="feb-pulse"></div>

    <div class="feb-left">
      <span class="feb-verb"><%= verb %></span>
      <span class="feb-sep">·</span>
      <span class="feb-cta"><%= cta %></span>
    </div>

    <div class="feb-right">
      <% if is_today %>
        <span class="feb-countdown" id="feb-countdown"></span>
      <% else %>
        <span class="feb-opens">Polls open 7 AM tomorrow</span>
      <% end %>
      <span class="feb-arrow">Learn More &amp; Mock-Vote →</span>
    </div>
  </a>

  <% if is_today %>
    <script>
      (function() {
        function tick() {
          var close = new Date();
          close.setHours(20, 0, 0, 0);
          var diff = Math.max(0, close - new Date());
          if (diff === 0) {
            document.getElementById('feb-countdown').textContent = 'Polls closed';
            return;
          }
          var h = Math.floor(diff / 3600000);
          var m = Math.floor((diff % 3600000) / 60000);
          var s = Math.floor((diff % 60000) / 1000);
          var pad = function(n) { return String(n).padStart(2, '0'); };
          document.getElementById('feb-countdown').textContent =
            pad(h) + ':' + pad(m) + ':' + pad(s) + ' until polls close';
        }
        tick();
        setInterval(tick, 1000);
      })();
    </script>
  <% end %>
<% end %>
─────────────────────────────────────────────────────────

---

## STEP 5 — Stylesheet

Create app/assets/stylesheets/election_bar.css with this content exactly:

─────────────────────────────────────────────────────────
/* ═══════════════════════════════════════════════════
   FORA ELECTION BAR
   Appears below top nav on May 18–19, 2026.
   Full-width, scarlet, pulsing. Routes to /votemay19.
   Remove or set show_bar_until after May 19.
═══════════════════════════════════════════════════ */

.fora-election-bar {
  display: flex;
  align-items: center;
  gap: 16px;
  width: 100%;
  background: #8b1a1a;                    /* --scarlet */
  padding: 11px 20px;
  text-decoration: none;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  border-bottom: 1px solid rgba(255,255,255,0.1);
  animation: feb-breathe 3s ease-in-out infinite;
  flex-shrink: 0;
}

/* Subtle breathing glow on the bar itself */
@keyframes feb-breathe {
  0%, 100% { box-shadow: inset 0 -2px 12px rgba(0,0,0,0.2); }
  50%       { box-shadow: inset 0 -2px 20px rgba(0,0,0,0.35),
                          0 2px 16px rgba(139,26,26,0.4); }
}

.fora-election-bar:hover {
  background: #a02020;
  animation: none;
  box-shadow: 0 2px 20px rgba(139,26,26,0.5);
}

/* Pulsing dot */
.feb-pulse {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: white;
  flex-shrink: 0;
  animation: feb-dot 1.2s ease-in-out infinite;
}

@keyframes feb-dot {
  0%, 100% { opacity: 1; transform: scale(1); }
  50%       { opacity: 0.4; transform: scale(0.55); }
}

/* Left text block */
.feb-left {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
  min-width: 0;
}

.feb-verb {
  font-family: 'Libre Baskerville', serif;
  font-size: 14px;
  font-weight: 700;
  color: white;
  white-space: nowrap;
  letter-spacing: 0.02em;
}

.feb-sep {
  color: rgba(255,255,255,0.35);
  font-size: 14px;
  flex-shrink: 0;
}

.feb-cta {
  font-family: 'Nunito', sans-serif;
  font-size: 12px;
  color: rgba(255,255,255,0.75);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Right block */
.feb-right {
  display: flex;
  align-items: center;
  gap: 14px;
  flex-shrink: 0;
}

.feb-countdown {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: rgba(255,255,255,0.65);
  letter-spacing: 0.06em;
}

.feb-opens {
  font-family: 'JetBrains Mono', monospace;
  font-size: 10px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: rgba(255,255,255,0.5);
}

.feb-arrow {
  font-family: 'Nunito', sans-serif;
  font-size: 12px;
  font-weight: 800;
  color: white;
  background: rgba(255,255,255,0.15);
  border: 1px solid rgba(255,255,255,0.25);
  border-radius: 4px;
  padding: 5px 12px;
  white-space: nowrap;
  transition: background 0.12s;
}

.fora-election-bar:hover .feb-arrow {
  background: rgba(255,255,255,0.25);
}

/* Mobile */
@media (max-width: 640px) {
  .feb-cta, .feb-sep, .feb-opens { display: none; }
  .feb-verb { font-size: 13px; }
}
─────────────────────────────────────────────────────────

---

## STEP 6 — Inject the partial into the layout

In app/views/layouts/application.html.erb, find the top nav render line
(something like `<%= render 'shared/nav' %>` or the nav partial call)
and add the election bar IMMEDIATELY AFTER it, before the ticker or main content:

  <%= render 'shared/nav' %>
  <%= render 'shared/election_bar' %>      <%# ← ADD THIS LINE %>
  <%= render 'shared/ticker' if @show_ticker %>
  <%= yield %>

If the layout uses a different structure (e.g. a wrapper div, or the nav is
inline rather than a partial), insert `<%= render 'shared/election_bar' %>`
as the first child inside the main content wrapper, directly below the closing
tag of whatever element contains the top nav.

---

## STEP 7 — Include the stylesheet

In app/assets/stylesheets/application.css (or application.scss), add:

  @import "election_bar";

OR if using the asset pipeline manifest (app/assets/config/manifest.js):

  //= require election_bar

---

## BEHAVIOR RULES

- Bar shows on: May 18, 2026 (day before) AND May 19, 2026 (election day)
- Bar disappears: automatically after May 19 (date comparison in ERB)
- May 18 copy: "Vote Tomorrow, May 19 · Pennsylvania Primary · Philadelphia · Click to learn more & cast a mock-ballot"
- May 19 copy: "Today is Election Day · Polls open 7 AM – 8 PM · Click to see your ballot & cast a mock-vote"
- May 19 adds a live countdown to 8 PM polls-close, rendered in JetBrains Mono
- Click destination: /votemay19 (fora.center/votemay19)
- No dismiss/close button — it's a time-sensitive civic alert, not a marketing banner
- No A/B test, no feature flag — just the date condition

---

## DO NOT

- Do not put this inside the nav partial — it must be outside/below the nav
- Do not add JavaScript frameworks; the countdown uses plain vanilla JS in a <script> tag
- Do not add cookies or session state for "already seen" — show it every visit during the window
- Do not change any nav styles, dashboard layout, widget grid, or ticker
- Do not change routing for any existing pages
- Do not add this to any page other than the dashboard layout (it should appear
  on Dashboard, Legislation, Issues, Events, Discourse — anywhere that uses
  application.html.erb as its layout)

---

## VERIFICATION

After implementation, confirm:
  - GET /votemay19 returns 200
  - The bar renders on /dashboard on May 18 and May 19 only
  - The bar does NOT render on any other date (test by temporarily changing
    show_bar_from to yesterday's date and verifying it disappears)
  - Clicking the bar routes to /votemay19
  - On May 19, the countdown ticks live in the browser
  - No layout shift or style collision with existing nav/ticker/widget grid
  - Mobile: bar still shows but secondary text collapses (see CSS @media rule)

---

## REFERENCE

Dashboard layout: fora_dashboard.html (v13 canonical)
Vote page HTML:   fora-vote-20260519.html → becomes app/views/vote/may19.html.erb
FORA CSS tokens:  --scarlet: #8b1a1a · --blue: #1b3a6b · font-serif: Libre Baskerville
                  --font-mono: JetBrains Mono · --font-ui: Nunito
Route name:       votemay19_path → /votemay19
