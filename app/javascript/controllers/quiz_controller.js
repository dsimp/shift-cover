import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "nextButton"]

  connect() {
    this.currentIndex = 0
    this.showQuestion(0)
  }

  showQuestion(index) {
    this.questionTargets.forEach((q, i) => {
      q.classList.toggle('d-none', i !== index)
    })
  }

  next() {
    if (this.currentIndex < this.questionTargets.length - 1) {
      this.currentIndex++
      this.showQuestion(this.currentIndex)
    } else {
      
    }
  }
}
