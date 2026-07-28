import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const timeout = this.element.dataset.flashTimeout
    const delay = timeout ? Number(timeout) : 3000

    this.timeoutId = setTimeout(() => {
      this.element.remove()
    }, delay)
  }

  disconnect() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }
}
