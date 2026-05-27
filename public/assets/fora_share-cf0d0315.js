import html2canvas from "html2canvas"

const FORA_DARK = {
  bg:      "#0b1f3a",
  text:    "#f0ebe0",
  muted:   "rgba(255,255,255,0.5)",
  accent:  "#b8860b",
  border:  "rgba(255,255,255,0.08)",
  good:    "#7acc7a",
  flag:    "#fac775"
}

function buildCardHTML(data) {
  const rows = (data.rows || []).map(r => `
    <div style="display:flex;justify-content:space-between;align-items:baseline;padding:6px 0;border-bottom:1px solid ${FORA_DARK.border};font-family:sans-serif;font-size:13px;">
      <span style="color:${FORA_DARK.muted};">${r.label}</span>
      <span style="color:${r.flag ? FORA_DARK.flag : FORA_DARK.good};font-weight:600;">${r.value}</span>
    </div>
  `).join("")

  const statBlock = data.stat ? `
    <div style="margin:12px 0 6px;">
      <div style="font-size:36px;font-weight:600;color:${FORA_DARK.text};line-height:1;">${data.stat}</div>
      <div style="font-size:13px;color:${FORA_DARK.muted};margin-top:4px;">${data.statLabel || ""}</div>
    </div>
  ` : ""

  return `
    <div style="
      width:600px;
      background:${FORA_DARK.bg};
      padding:28px 32px 22px;
      font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;
      box-sizing:border-box;
    ">
      <div style="font-size:10px;letter-spacing:2px;text-transform:uppercase;color:${FORA_DARK.accent};margin-bottom:10px;">FORA · Civic Intelligence</div>
      <div style="font-size:13px;color:${FORA_DARK.muted};margin-bottom:2px;">${data.official || ""}</div>
      <div style="font-size:15px;font-weight:600;color:${FORA_DARK.text};margin-bottom:4px;">${data.title || ""}</div>
      ${statBlock}
      ${data.desc ? `<div style="font-size:13px;color:${FORA_DARK.muted};line-height:1.5;margin:10px 0 14px;">${data.desc}</div>` : ""}
      ${rows ? `<div style="margin-top:${data.stat ? 16 : 8}px;">${rows}</div>` : ""}
      <div style="display:flex;justify-content:space-between;align-items:center;margin-top:18px;padding-top:12px;border-top:1px solid ${FORA_DARK.border};">
        <span style="font-size:10px;letter-spacing:1px;text-transform:uppercase;color:${FORA_DARK.accent};">fora.center</span>
        <span style="font-size:10px;color:${FORA_DARK.muted};">${data.date || new Date().toLocaleDateString("en-US",{month:"long",year:"numeric"})}</span>
      </div>
    </div>
  `
}

async function generateCard(data) {
  const container = document.createElement("div")
  container.style.cssText = "position:fixed;left:-9999px;top:0;z-index:-1;"
  container.innerHTML = buildCardHTML(data)
  document.body.appendChild(container)

  const inner = container.firstElementChild
  const canvas = await html2canvas(inner, {
    scale: 2,
    useCORS: true,
    backgroundColor: "#0b1f3a",
    logging: false,
    width: 600,
    height: inner.offsetHeight
  })

  document.body.removeChild(container)
  return canvas
}

async function shareCard(data) {
  const btn = data._btn
  if (btn) { btn.style.opacity = "0.4"; btn.style.pointerEvents = "none" }

  try {
    const canvas = await generateCard(data)
    const blob = await new Promise(res => canvas.toBlob(res, "image/png"))
    const file = new File([blob], "fora-civic-card.png", { type: "image/png" })
    const url  = window.location.href

    if (navigator.canShare && navigator.canShare({ files: [file] })) {
      await navigator.share({
        title: `${data.official} — FORA`,
        text:  `${data.title} · via FORA`,
        url:   url,
        files: [file]
      })
    } else if (navigator.share) {
      await navigator.share({ title: `${data.official} — FORA`, url })
    } else {
      const a = document.createElement("a")
      a.href = URL.createObjectURL(blob)
      a.download = "fora-civic-card.png"
      a.click()
    }
  } catch(e) {
    if (e.name !== "AbortError") console.warn("FORA share error:", e)
  } finally {
    if (btn) { btn.style.opacity = ""; btn.style.pointerEvents = "" }
  }
}

window.foraShare = shareCard
