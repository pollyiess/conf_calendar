import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const card = this.element.firstElementChild
    if (!card) return

    card.classList.add("ring-2", "ring-emerald-400")
    
    this.timer = setTimeout(() => card.classList.remove("ring-2", "ring-emerald-400"), 4000)
  }

  disconnect() {
    clearTimeout(this.timer)
  }
}