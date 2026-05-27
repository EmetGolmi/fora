# Claude Code Prompt — Go Elsewhere Major Upgrade

Run this entire prompt in Claude Code from `~/Documents/GoElsewhere/goelsewhere/`

---

## OVERVIEW

This prompt does five things in one shot:
1. Add regional airports (West Coast + Mountain West) to the airport proximity table in server.js
2. Add world parks data (from world_parks_data.js) merged with US parks, with gateway airports
3. Add `nearestParks` field to relevant corridors for Nature & Escape vibe matching
4. Add trip length presets to the UI (Weekend / Long Weekend / Week / Two Weeks / Custom)
5. Tighten budget scoring: 85–100% sweet spot, hard 5% over-budget cap, tier-based results instead of filtering out destinations

---

## STEP 1 — Create world_parks_data.js in the project

Create a new file `world_parks_data.js` in the project root with the following content:

```javascript
export const WORLD_PARKS = [
  { name: "El Yunque National Forest", country: "Puerto Rico (US)", region: "Caribbean", lat: 18.2951, lng: -65.8000, placeId: "ChIJydD9LrOhBIwR0SSym7z2QoM", rating: 4.8, ratingCount: 14934, gateway: "SJU (San Juan, 45 min)", tags: ["rainforest", "waterfall", "hiking", "bioluminescence nearby", "US territory"], notes: "The only tropical rainforest in the US National Forest system. Waterfalls, tower views, bioluminescent bays nearby." },
  { name: "Viñales Valley", country: "Cuba", region: "Caribbean", lat: 22.6052, lng: -83.7256, placeId: "ChIJnYb1uHRRy4gR9ww0pzz3NM8", rating: 4.8, ratingCount: 595, gateway: "HAV (Havana, 3 hrs drive)", tags: ["mogotes", "limestone", "tobacco farms", "horseback riding", "caves", "UNESCO"], notes: "UNESCO limestone mogotes rising from tobacco-farm valleys. Cuba's most otherworldly landscape." },
  { name: "Parque Nacional Los Glaciares", country: "Argentina", region: "South America / Patagonia", lat: -50.3306, lng: -73.2342, placeId: "ChIJVZJRWSiypL0R3dHwpGmtXeY", rating: 4.9, ratingCount: 6354, gateway: "FTE (El Calafate, 1 hr)", tags: ["glacier", "Perito Moreno", "UNESCO", "hiking", "Patagonia", "calving ice"], notes: "Home to Perito Moreno Glacier — one of the few advancing glaciers on Earth. Audible calving from boardwalks." },
  { name: "Torres del Paine National Park", country: "Chile", region: "South America / Patagonia", lat: -50.9423, lng: -73.4068, placeId: "ChIJB6_bgwEbpb0RWM4aRVcmn70", rating: 4.8, ratingCount: 10942, gateway: "PUQ (Punta Arenas, 3.5 hrs drive)", tags: ["granite towers", "W Trek", "glacier", "guanaco", "condor", "hiking", "Patagonia", "UNESCO biosphere"], notes: "The W Trek is one of the world's great multi-day hikes. Granite towers, turquoise lakes, Grey Glacier." },
  { name: "Salar de Uyuni", country: "Bolivia", region: "South America / Andes", lat: -20.1338, lng: -67.4891, placeId: "ChIJ14vhJbOEVZERtniCFToY5Aw", rating: 4.8, ratingCount: 3056, gateway: "UYU (Uyuni, on-site) via LPB (La Paz)", tags: ["salt flat", "mirror effect", "cactus islands", "flamingos", "altitude", "surreal"], notes: "World's largest salt flat. Wet season mirror effect reflects the entire sky. Altitude 3,656m — acclimatize first." },
  { name: "Chapada Diamantina National Park", country: "Brazil", region: "South America / Brazil", lat: -12.7927, lng: -41.4123, placeId: "ChIJvxVjS7whQgcRvbnUHVNZb1s", rating: 4.9, ratingCount: 10836, gateway: "SSA (Salvador, 4 hrs drive) or LEC (Lençóis, airstrip)", tags: ["table mountains", "waterfalls", "caves", "crystal rivers", "multi-day trek", "Bahia"], notes: "Brazil's secret: table-top mountains, crystal-blue rivers, caves, waterfalls. Base in Lençóis. 4+ days minimum." },
  { name: "Parque Nacional Galápagos", country: "Ecuador", region: "South America / Pacific", lat: -0.6144, lng: -90.3451, placeId: "ChIJQ8p4MDxfqpoRW7ZiDEGJ3Io", rating: 4.8, ratingCount: 3554, gateway: "GYE or UIO (Ecuador mainland) → GPS (Baltra) or SCY (San Cristóbal)", tags: ["Darwin", "endemic species", "marine iguana", "giant tortoise", "UNESCO", "snorkeling", "wildlife"], notes: "Darwin's laboratory. 97% of reptile species found nowhere else. Marine iguanas, flightless cormorants, Galápagos penguins." },
  { name: "Banff National Park", country: "Canada", region: "North America / Canada", lat: 51.4968, lng: -115.9281, placeId: "ChIJlZGSjCtmd1MR5tfKrGjincA", rating: 4.8, ratingCount: 29822, gateway: "YYC (Calgary, 1.5 hrs drive)", tags: ["Canadian Rockies", "turquoise lakes", "Moraine Lake", "Lake Louise", "Icefields Parkway", "wildlife", "skiing"], notes: "Turquoise glacier-fed lakes (Moraine, Louise), Rocky Mountain peaks, Columbia Icefield. Canada's crown jewel." },
  { name: "Plitvice Lakes National Park", country: "Croatia", region: "Europe / Balkans", lat: 44.8654, lng: 15.5820, placeId: "ChIJPQ_Z_mxeYUcRcF6aN_iPGgU", rating: 4.8, ratingCount: 124484, gateway: "ZAG (Zagreb, 2 hrs) or SPU (Split, 2.5 hrs)", tags: ["turquoise lakes", "waterfalls", "boardwalks", "UNESCO", "hiking", "Croatia"], notes: "16 terraced turquoise lakes connected by waterfalls and wooden boardwalks. Go in winter for zero crowds and frozen magic." },
  { name: "Dolomiti Bellunesi National Park", country: "Italy", region: "Europe / Alps", lat: 46.1699, lng: 12.0366, placeId: "ChIJX0Pi4gf8eEcRcsr107cGc1o", rating: 4.7, ratingCount: 3031, gateway: "VCE (Venice, 1.5 hrs) or BLQ (Bologna, 2 hrs)", tags: ["Dolomites", "limestone spires", "UNESCO", "hiking", "no crowds", "Italian Alps"], notes: "Least-visited corner of the Dolomites UNESCO site. Primordial limestone, isolated villages, no mass tourism." },
  { name: "Simien Mountains National Park", country: "Ethiopia", region: "Africa / East Africa", lat: 13.2027, lng: 37.8876, placeId: "ChIJnfgWbdTBaRYRLWISc9-EAnc", rating: 4.5, ratingCount: 294, gateway: "GDQ (Gondar, 2 hrs drive) via ADD (Addis Ababa)", tags: ["gelada baboon", "Ethiopian wolf", "escarpment", "trekking", "UNESCO", "highlands", "Ras Dashen"], notes: "Dramatic highland escarpments, gelada baboons at cliff edges at sunset. Ras Dashen is Africa's 4th highest peak." },
  { name: "Erta Ale / Danakil Depression", country: "Ethiopia", region: "Africa / East Africa", lat: 13.6069, lng: 40.6617, placeId: "ChIJa7-GnkJgFBYRGLm54re0yww", rating: 4.6, ratingCount: 336, gateway: "MQX (Mekele, 6+ hrs 4WD) via ADD (Addis Ababa)", tags: ["lava lake", "active volcano", "sulfur springs", "below sea level", "extreme", "Afar", "most alien landscape"], notes: "Most alien landscape on Earth — 116m below sea level, neon sulfur springs, active lava lake. Hottest inhabited place on the planet." },
  { name: "Namib-Naukluft National Park", country: "Namibia", region: "Africa / Southern Africa", lat: -23.0833, lng: 15.1667, placeId: "ChIJVWbMOIBtchwRDhKhKfVF2_Y", rating: 4.6, ratingCount: 2196, gateway: "WDH (Windhoek, 4 hrs drive) or self-drive", tags: ["sand dunes", "Sossusvlei", "Deadvlei", "world's oldest desert", "photography", "Dune 45", "orange dunes"], notes: "World's oldest desert. Sossusvlei's burnt-orange dunes at sunrise, Deadvlei's ancient dead trees on white clay. Photography icon." },
  { name: "Virunga National Park", country: "Democratic Republic of Congo", region: "Africa / Central Africa", lat: -0.0502, lng: 29.5143, placeId: "ChIJ0-rNko3FYBcRPzjbi0xEgoU", rating: 4.4, ratingCount: 525, gateway: "GOM (Goma, DRC) or KGL (Kigali, Rwanda, 3 hrs)", tags: ["mountain gorilla", "Nyiragongo volcano", "lava lake", "Africa's oldest park", "trekking", "extreme"], notes: "Africa's oldest park. Mountain gorilla trekking and Nyiragongo lava lake summit. Most profound wildlife encounter on earth. Check current security advisories." },
  { name: "Sagarmatha National Park", country: "Nepal", region: "Asia / Himalayas", lat: 27.9324, lng: 86.7014, placeId: "ChIJW_9Y6LlU6DkRvkeHfWBmlKc", rating: 4.6, ratingCount: 2205, gateway: "KTM (Kathmandu) → LUA (Lukla, 30 min flight)", tags: ["Everest", "EBC trek", "Himalaya", "UNESCO", "Sherpa culture", "glacier", "highest peaks"], notes: "Three of the six tallest mountains including Everest. EBC trek through Sherpa villages, glacial rivers, swing bridges." },
  { name: "Jiuzhai Valley National Park", country: "China", region: "Asia / China", lat: 33.2600, lng: 103.9186, placeId: "ChIJKWccnva99zYRxgz2tcjo_ck", rating: 4.7, ratingCount: 1096, gateway: "JZH (Jiuzhaigou, 40 min) or CTU (Chengdu, high-speed rail 2 hrs + bus)", tags: ["turquoise lakes", "multi-colored pools", "waterfalls", "Tibetan valley", "UNESCO", "fairy land", "boardwalk"], notes: "Tiered turquoise lakes and multi-colored pools in a Tibetan valley. Looks like a painting. Book ahead — daily visitor cap." },
  { name: "Zhangjiajie National Forest Park", country: "China", region: "Asia / China", lat: 29.3153, lng: 110.4348, placeId: "ChIJoaxDGsqvmzYRbwukZex5gKE", rating: 4.7, ratingCount: 1118, gateway: "DYG (Zhangjiajie, 1 hr)", tags: ["sandstone pillars", "Avatar", "Hallelujah Mountains", "glass bridge", "cable car", "Hunan", "China"], notes: "The floating sandstone pillars that inspired Avatar's Hallelujah Mountains. Glass-bottomed bridges, vertiginous cable cars. 2 full days minimum." },
  { name: "Kawah Ijen Volcano", country: "Indonesia", region: "Asia / Southeast Asia", lat: -8.0742, lng: 114.2232, placeId: "ChIJX9sVyVBO0S0Rcvyc3gHwCcM", rating: 4.8, ratingCount: 577, gateway: "BWX (Banyuwangi, 1.5 hrs drive) via SUB (Surabaya)", tags: ["blue fire", "active volcano", "acid lake", "sulfur", "night hike", "Java", "Indonesia"], notes: "World's only blue fire volcano — electric-blue sulfuric flames visible only at night. Hike starts at 2am. Gas mask required." },
  { name: "Milford Sound / Piopiotahi", country: "New Zealand", region: "Oceania / New Zealand", lat: -44.6414, lng: 167.8974, placeId: "ChIJ4UlLuk3g1akRAN5kq4bvACo", rating: 4.8, ratingCount: 2637, gateway: "ZQN (Queenstown, 4 hrs drive) or direct charter flight", tags: ["fiord", "waterfalls", "dolphins", "seals", "Fiordland", "UNESCO", "cruise", "New Zealand"], notes: "Sheer cliffs, cascading waterfalls, dolphins, seals. Drive through Homer Tunnel — the road itself is legendary." },
  { name: "Waitomo Glowworm Caves", country: "New Zealand", region: "Oceania / New Zealand", lat: -38.2607, lng: 175.1036, placeId: "ChIJfVTj8363bG0R8p8w_eGxLJI", rating: 4.5, ratingCount: 13024, gateway: "AKL (Auckland, 2 hrs drive) or HLZ (Hamilton, 1 hr)", tags: ["glowworms", "bioluminescent", "caves", "boat ride", "North Island", "unique", "New Zealand"], notes: "Thousands of bioluminescent Arachnocampa luminosa create a living starfield on cave ceilings. Silent boat ride underneath." },
];
```

---

## STEP 2 — Add regional airports to server.js airport table

Find the `AIRPORT_COORDS` object in server.js (the lat/lng table used by `/api/airports`). Add ALL of the following entries. Do not remove any existing entries.

```javascript
// West Coast regional
SBA: { lat: 34.4262, lng: -119.8403, name: 'Santa Barbara', driveNote: 'Central Coast · Channel Islands access' },
SBP: { lat: 35.2368, lng: -120.6424, name: 'San Luis Obispo', driveNote: 'Central Coast · Wine country' },
SMF: { lat: 38.6954, lng: -121.5908, name: 'Sacramento', driveNote: 'NorCal · Lake Tahoe 2 hrs · Gold Country' },
FAT: { lat: 36.7762, lng: -119.7181, name: 'Fresno', driveNote: 'Central Valley · Yosemite 1.5 hrs · Sequoia 1 hr' },
MFR: { lat: 42.3742, lng: -122.8735, name: 'Medford', driveNote: 'Southern Oregon · Crater Lake 1.5 hrs' },
EUG: { lat: 44.1246, lng: -123.2119, name: 'Eugene', driveNote: 'Pacific NW · Oregon Coast 1 hr' },
GEG: { lat: 47.6199, lng: -117.5339, name: 'Spokane', driveNote: 'Inland NW · Glacier NP 4 hrs · Coeur d\'Alene 30 min' },

// Mountain West — Idaho
BOI: { lat: 43.5644, lng: -116.2228, name: 'Boise', driveNote: 'High Desert · Snake River Canyon' },
SUN: { lat: 43.5044, lng: -114.2963, name: 'Hailey/Sun Valley', driveNote: 'Central Idaho · Sawtooth Mountains' },
IDA: { lat: 43.5146, lng: -112.0702, name: 'Idaho Falls', driveNote: 'Eastern Idaho · Yellowstone south entrance 1.5 hrs' },

// Mountain West — Montana/Wyoming
FCA: { lat: 48.3105, lng: -114.2560, name: 'Kalispell', driveNote: 'Glacier NP gateway · West entrance 30 min' },
BZN: { lat: 45.7775, lng: -111.1603, name: 'Bozeman', driveNote: 'Southern Montana · Yellowstone north entrance 1.5 hrs · Big Sky 45 min' },
JAC: { lat: 43.6073, lng: -110.7377, name: 'Jackson Hole', driveNote: 'Grand Teton NP gateway · Yellowstone south 1 hr' },

// Mountain West — Colorado
ASE: { lat: 39.2232, lng: -106.8688, name: 'Aspen', driveNote: 'Colorado Rockies · Skiing' },
GJT: { lat: 39.1224, lng: -108.5268, name: 'Grand Junction', driveNote: 'Western Slope · Arches NP 1.5 hrs · Canyonlands 2 hrs' },
DRO: { lat: 37.1515, lng: -107.7538, name: 'Durango', driveNote: 'Southwest CO · Mesa Verde NP 35 min · Silverton 50 min' },
MTJ: { lat: 38.5098, lng: -107.8938, name: 'Montrose', driveNote: 'Black Canyon NP 15 min · Telluride 1 hr' },

// Mountain West — Utah/Arizona
SGU: { lat: 37.0363, lng: -113.5103, name: 'St. George', driveNote: 'Southwest Utah · Zion NP 45 min · Bryce Canyon 2 hrs' },
CNY: { lat: 38.7559, lng: -109.7548, name: 'Moab', driveNote: 'Canyon Country · Arches NP 5 min · Canyonlands 30 min' },
FLG: { lat: 35.1385, lng: -111.6709, name: 'Flagstaff', driveNote: 'Colorado Plateau · Grand Canyon South Rim 1.5 hrs' },

// Nevada
RNO: { lat: 39.4991, lng: -119.7681, name: 'Reno', driveNote: 'Sierra Nevada · Lake Tahoe 45 min · Burning Man corridor' },

// Canada (for Banff gateway)
YYC: { lat: 51.1315, lng: -114.0108, name: 'Calgary', driveNote: 'Banff NP 1.5 hrs · Jasper 4 hrs · Canadian Rockies gateway' },
```

---

## STEP 3 — Add nearestParks to corridors.js destinations

In corridors.js, add a `nearestParks` array field to the following destinations. Only add to destinations where there's a real, meaningful park within the trip experience (not just a distant coincidence).

```
// US domestic / mountain destinations already in domestic-towns or corridors:
// Kalispell/FCA corridor → nearestParks: ['Glacier National Park']
// Bozeman/BZN → nearestParks: ['Yellowstone National Park', 'Glacier NP (4 hrs)']
// Jackson/JAC → nearestParks: ['Grand Teton National Park', 'Yellowstone National Park']
// Durango/DRO → nearestParks: ['Mesa Verde National Park']
// Moab/CNY → nearestParks: ['Arches National Park', 'Canyonlands National Park']
// St. George/SGU → nearestParks: ['Zion National Park', 'Bryce Canyon National Park']
// Flagstaff/FLG → nearestParks: ['Grand Canyon National Park']
// Fresno/FAT → nearestParks: ['Yosemite National Park', 'Sequoia National Park']
// Medford/MFR → nearestParks: ['Crater Lake National Park']

// International corridors — add nearestParks where applicable:
// KEF (Iceland) → nearestParks: ['Þingvellir National Park', 'Vatnajökull National Park']
// YYC (Calgary/Banff) → nearestParks: ['Banff National Park', 'Jasper National Park']
// NRT Hokkaido → nearestParks: ['Shiretoko National Park', 'Daisetsuzan National Park']
// CTG (Cartagena) corridor → if includes nature tag → nearestParks: ['Tayrona National Park']
// LIM (Lima) corridor → nearestParks: ['Huascarán National Park', 'Manu National Park']
// BOG/MDE (Colombia) → nearestParks: ['El Cocuy National Park', 'Tayrona National Park']
// SJU (Puerto Rico) → nearestParks: ['El Yunque National Forest']
// AKL (Auckland) → nearestParks: ['Waitomo Glowworm Caves', 'Tongariro National Park']
// ZQN (Queenstown) → nearestParks: ['Milford Sound / Fiordland', 'Mount Aspiring NP']
```

For any corridor destination that already has a `vibes` array including `'nature'` or `'nature-escape'`, ensure `nearestParks` is populated if a real park exists nearby.

---

## STEP 4 — Add world parks array to server.js

At the top of server.js (after existing requires/imports), add:

```javascript
const { WORLD_PARKS } = require('./world_parks_data.js');
```

Change the export in world_parks_data.js from ES module `export const` to CommonJS `module.exports = { WORLD_PARKS }` so it works with the existing Node/Express setup.

Add a new endpoint:

```javascript
app.get('/api/parks', (req, res) => {
  const { region, tag, gateway } = req.query;
  let parks = [...US_PARKS, ...WORLD_PARKS]; // merge with existing US parks array if present, otherwise just WORLD_PARKS
  if (region) parks = parks.filter(p => p.region && p.region.toLowerCase().includes(region.toLowerCase()));
  if (tag) parks = parks.filter(p => p.tags && p.tags.some(t => t.toLowerCase().includes(tag.toLowerCase())));
  if (gateway) parks = parks.filter(p => p.gateway && p.gateway.toLowerCase().includes(gateway.toLowerCase()));
  res.json({ parks, total: parks.length });
});
```

---

## STEP 5 — Trip length presets in index.html

In Step 2 of the wizard (currently where nights are entered), replace the plain number input with a preset selector plus a custom override:

```
[Weekend]  [Long Weekend]  [Week]  [Two Weeks]  [Custom]
  2 nights     3–4 nights   6–7 nights  12–14 nights   [___] nights
```

Implementation:
- Show as clickable chips (same style as vibe chips)
- Selecting a preset fills `nights` with the midpoint value: Weekend=2, Long Weekend=3, Week=7, Two Weeks=14
- Selecting "Custom" reveals a number input (min 1, max 30)
- The selected nights value should be clearly visible below the chips: "7 nights selected"
- Pass `nights` to the search payload exactly as before — nothing else in the API changes

---

## STEP 6 — Tighten budget scoring in server.js

Find the scoring function (where `totalCost` is compared to `budget`). Replace the current scoring logic with this:

```javascript
// Budget fit scoring — replaces current implementation
const budgetRatio = totalCost / budget; // using recommendedRate (tier-matched), not flat rate

let budgetScore = 0;

if (budgetRatio > 1.05) {
  // Hard cap: more than 5% over budget → exclude from results entirely
  return null; // filter this destination out
} else if (budgetRatio > 1.0) {
  // 0–5% over: show with warning, low score
  budgetScore = 5;
  destination.budgetWarning = `Over budget by $${Math.round(totalCost - budget)}`;
} else if (budgetRatio >= 0.85) {
  // 85–100%: sweet spot — full points
  budgetScore = 30;
} else if (budgetRatio >= 0.70) {
  // 70–84%: decent fit but leaving money on the table
  budgetScore = 15;
  destination.budgetNote = `$${Math.round(budget - totalCost)} left over — consider upgrading your room`;
} else if (budgetRatio >= 0.55) {
  // 55–69%: destination is too cheap for budget — show nicer tier
  budgetScore = 8;
  destination.budgetNote = `Well under budget — we've shown you the nicest room available here`;
} else {
  // Under 55%: destination is a significant mismatch — deprioritize but don't hide
  budgetScore = 2;
}

// Replace old budget score with budgetScore in total scoring
```

Also update the quality tier logic so that when a destination is "too cheap" for the budget (ratio < 0.70), it automatically shows `nightlyHotelRateUpscale` instead of mid. The result card should always reflect which tier is being shown.

---

## STEP 7 — Add short-trip destinations to corridors

For Weekend and Long Weekend trips (2–4 nights), make sure these destination types surface well. Add a `minNights` and `maxNights` field to all corridor destinations:

```
// Destinations ideal for weekend trips (2–3 nights):
// MBJ Negril, SJU San Juan, CUN Tulum, MIA Miami, MCO Orlando area
// BOS Boston, PHL Philadelphia area, DCA DC, BNA Nashville, CLT Charlotte
// All domestic towns (Gulf Coast) — great for 3-night drives
// minNights: 2, maxNights: 4

// Destinations that need a full week minimum:
// KEF Iceland, ARN Scandinavia, NRT Japan, YYC Banff, AKL New Zealand
// Any destination with flightHours > 8 (flight time too long for short trips)
// minNights: 6, maxNights: 21

// Destinations that work for any length:
// Most Caribbean/Mexico destinations
// Most domestic nature/park trips
// minNights: 3, maxNights: 14
```

In the scoring function, add a nights-fit check:

```javascript
// Penalize destinations that don't fit the trip length
if (nights < destination.minNights) {
  score -= 25; // significant penalty — destination needs more time than available
  destination.nightsWarning = `${destination.name} really benefits from ${destination.minNights}+ nights`;
}
if (nights > destination.maxNights) {
  score -= 10; // mild penalty — could overstay but it's workable
}
```

---

## STEP 8 — Commit everything

```bash
git add -A
git commit -m "feat: regional airports (West/Mountain), world parks data, trip length presets, budget scoring tightened, nearestParks field, minNights/maxNights scoring"
git push origin main
```

---

## NOTES FOR CLAUDE CODE

- Do not remove any existing airports from AIRPORT_COORDS
- Do not remove any existing corridor destinations
- world_parks_data.js should be CommonJS (module.exports) not ES module, to match the existing server.js style
- The `/api/parks` endpoint is new — it doesn't replace anything
- The trip length presets (Step 5) are UI only — the nights value passed to the API is unchanged
- Budget scoring change (Step 6) is the most important — make sure `return null` actually filters the destination from the results array before it's returned to the client
- Test the scoring change by searching $500 budget, 2 adults, 2 nights — should return Caribbean/domestic short-haul, NOT Iceland or Japan
