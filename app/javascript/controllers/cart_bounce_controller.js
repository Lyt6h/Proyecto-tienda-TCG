import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.addEventListener("turbo:submit-end", this.onCartAdd.bind(this))
  }

  disconnect() {
    document.removeEventListener("turbo:submit-end", this.onCartAdd.bind(this))
  }

  onCartAdd(event) {
    const action = event.detail?.formSubmission?.fetchRequest?.url?.toString() || ""
    if (!action.includes("cart")) return
    if (!event.detail.success) return

    const bag = document.getElementById("cart-bag-btn")
    if (!bag) return

    bag.classList.remove("cart-bounce")
    requestAnimationFrame(() => requestAnimationFrame(() => {
      bag.classList.add("cart-bounce")
      bag.addEventListener("animationend", () => bag.classList.remove("cart-bounce"), { once: true })
    }))
  }
}