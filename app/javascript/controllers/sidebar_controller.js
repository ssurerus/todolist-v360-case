import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "title", "itemsContainer"]

  toggle() {
    this.panelTarget.classList.toggle("-translate-x-full")
    this.titleTarget.classList.toggle("lg:ml-[440px]")
    this.titleTarget.classList.toggle("lg:ml-10")
    this.itemsContainerTarget.classList.toggle("lg:pl-[440px]")
  }

closeOnMobile() {
  if (window.innerWidth < 768) {
    this.toggle()
  }
}


}