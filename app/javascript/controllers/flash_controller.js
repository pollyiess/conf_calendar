import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.hideTimer = setTimeout(() => this.hide(), 4000)
  }

  disconnect() {
    clearTimeout(this.hideTimer)
    clearTimeout(this.removeTimer)
  }

  hide() {
    this.element.classList.add("opacity-0")
    this.removeTimer = setTimeout(() => this.element.remove(), 500)
  }
}