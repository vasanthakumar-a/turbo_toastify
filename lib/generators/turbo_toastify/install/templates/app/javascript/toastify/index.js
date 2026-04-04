const POSITIONS = {
  TOP_RIGHT: "top-right",
  TOP_LEFT: "top-left",
  TOP_CENTER: "top-center",
  BOTTOM_RIGHT: "bottom-right",
  BOTTOM_LEFT: "bottom-left",
  BOTTOM_CENTER: "bottom-center",
}

const THEMES = { LIGHT: "light", DARK: "dark", COLORED: "colored" }
const TRANSITIONS = { SLIDE: "slide", BOUNCE: "bounce", ZOOM: "zoom", FLIP: "flip", FADE: "fade" }
const TYPES = { SUCCESS: "success", ERROR: "error", WARNING: "warning", INFO: "info", DEFAULT: "default" }

const ICONS = {
  success: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="20" height="20"><circle cx="12" cy="12" r="10"/><path d="M8 12l3 3 5-5"/></svg>`,
  error: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="20" height="20"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>`,
  warning: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="20" height="20"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>`,
  info: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="20" height="20"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>`,
  default: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="20" height="20"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>`,
}

const ENTER_ANIMS = {
  slide: { right: "Toastify__slideInRight", left: "Toastify__slideInLeft", center: "Toastify__slideInDown", bottom: "Toastify__slideInUp" },
  bounce: { right: "Toastify__bounceInRight", left: "Toastify__bounceInRight", center: "Toastify__bounceInRight", bottom: "Toastify__bounceInRight" },
  zoom: { right: "Toastify__zoomIn", left: "Toastify__zoomIn", center: "Toastify__zoomIn", bottom: "Toastify__zoomIn" },
  flip: { right: "Toastify__flipIn", left: "Toastify__flipIn", center: "Toastify__flipIn", bottom: "Toastify__flipIn" },
  fade: { right: "Toastify__fadeIn", left: "Toastify__fadeIn", center: "Toastify__fadeIn", bottom: "Toastify__fadeIn" },
}

const defaults = {
  position: POSITIONS.TOP_RIGHT,
  autoClose: 5000,
  theme: THEMES.LIGHT,
  transition: TRANSITIONS.SLIDE,
  closeButton: true,
  pauseOnHover: true,
  draggable: true,
}

const containers = {}

function getContainer(position) {
  if (containers[position]) return containers[position]

  const el = document.createElement("div")
  el.className = `Toastify__toast-container Toastify__toast-container--${position}`
  el.setAttribute("data-position", position)
  document.body.appendChild(el)
  containers[position] = el
  return el
}

function getEnterAnim(transition, position) {
  const map = ENTER_ANIMS[transition] || ENTER_ANIMS.slide
  if (position.includes("right")) return map.right
  if (position.includes("left")) return map.left
  if (position.startsWith("bottom")) return map.bottom
  return map.center
}

function dismiss(toast) {
  if (!toast || toast._dismissing) return
  toast._dismissing = true
  clearTimeout(toast._timer)

  toast.classList.add("Toastify__toast--exit")
  toast.addEventListener("animationend", () => {
    toast.remove()
  }, { once: true })
}

function show(message, options = {}) {
  const opts = { ...defaults, ...options }
  const { position, autoClose, theme, transition, closeButton, pauseOnHover, draggable, type = TYPES.DEFAULT } = opts

  const container = getContainer(position)
  const isBottom = position.startsWith("bottom")

  const toast = document.createElement("div")
  toast.className = [
    "Toastify__toast",
    `Toastify__toast--${type}`,
    theme === THEMES.DARK ? "Toastify__toast--dark" : "",
    theme === THEMES.COLORED ? "Toastify__toast--colored" : "",
  ].filter(Boolean).join(" ")

  const enterAnim = getEnterAnim(transition, position)
  toast.style.setProperty("--enter-anim", enterAnim)
  toast.classList.add("Toastify__toast--enter")

  const progressBar = autoClose
    ? `<div class="Toastify__progress-bar Toastify__progress-bar--${type}" style="animation-duration:${autoClose}ms;"></div>`
    : ""

  const closeBtn = closeButton
    ? `<button class="Toastify__close-button" aria-label="Close toast">&#x2715;</button>`
    : ""

  toast.innerHTML = `
    <div class="Toastify__toast-body">
      <div class="Toastify__toast-icon">${ICONS[type] || ICONS.default}</div>
      <div class="Toastify__toast-message">${message}</div>
    </div>
    ${closeBtn}
    ${progressBar}
  `

  toast.querySelector(".Toastify__close-button")?.addEventListener("click", () => dismiss(toast))

  if (autoClose) {
    toast._timer = setTimeout(() => dismiss(toast), autoClose)
  }

  if (pauseOnHover && autoClose) {
    const pb = toast.querySelector(".Toastify__progress-bar")
    toast.addEventListener("mouseenter", () => {
      clearTimeout(toast._timer)
      pb?.style.setProperty("animation-play-state", "paused")
    })
    toast.addEventListener("mouseleave", () => {
      pb?.style.setProperty("animation-play-state", "running")
      toast._timer = setTimeout(() => dismiss(toast), autoClose / 2)
    })
  }

  if (draggable) {
    let startX = 0
    let currentX = 0
    let dragging = false

    toast.addEventListener("pointerdown", (e) => {
      startX = e.clientX
      dragging = true
      toast.style.transition = "none"
      toast.setPointerCapture(e.pointerId)
    })

    toast.addEventListener("pointermove", (e) => {
      if (!dragging) return
      currentX = e.clientX - startX
      toast.style.transform = `translateX(${currentX}px)`
      toast.style.opacity = `${1 - Math.abs(currentX) / 150}`
    })

    toast.addEventListener("pointerup", () => {
      dragging = false
      toast.style.transition = ""
      if (Math.abs(currentX) > 80) {
        dismiss(toast)
      } else {
        toast.style.transform = ""
        toast.style.opacity = ""
      }
      currentX = 0
    })
  }

  if (isBottom) container.appendChild(toast)
  else container.insertBefore(toast, container.firstChild)

  return toast
}

const TurboToastify = {
  success: (msg, opts) => show(msg, { ...opts, type: TYPES.SUCCESS }),
  error: (msg, opts) => show(msg, { ...opts, type: TYPES.ERROR }),
  warning: (msg, opts) => show(msg, { ...opts, type: TYPES.WARNING }),
  info: (msg, opts) => show(msg, { ...opts, type: TYPES.INFO }),
  show: (msg, opts) => show(msg, opts),
  dismiss,
  POSITIONS,
  THEMES,
  TRANSITIONS,
  defaults,
}

window.TurboToastify = TurboToastify

export default TurboToastify
