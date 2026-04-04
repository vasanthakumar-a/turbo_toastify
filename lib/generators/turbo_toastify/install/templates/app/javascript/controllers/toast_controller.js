import { Controller } from "@hotwired/stimulus"
import TurboToastify from "../toastify/index"

export default class extends Controller {
  static values = {
    message: String,
    type: { type: String, default: "default" },
    position: { type: String, default: "top-right" },
    autoClose: { type: Number, default: 5000 },
    theme: { type: String, default: "light" },
    transition: { type: String, default: "slide" },
  }

  connect() {
    requestAnimationFrame(() => {
      if (this.messageValue) {
        TurboToastify[this.typeValue]?.(this.messageValue, {
          position: this.positionValue,
          autoClose: this.autoCloseValue,
          theme: this.themeValue,
          transition: this.transitionValue,
        }) ?? TurboToastify.show(this.messageValue, {
          type: this.typeValue,
          position: this.positionValue,
          autoClose: this.autoCloseValue,
          theme: this.themeValue,
          transition: this.transitionValue,
        })
      }

      this.element.remove()
    })
  }
}
