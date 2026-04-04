# Configure defaults for toasts emitted from the flash partial.
# These values are read server-side and injected into Stimulus values.
Rails.application.config.x.turbo_toastify = {
  position: "top-right",
  auto_close: 5000,
  theme: "light",
  transition: "slide"
}
