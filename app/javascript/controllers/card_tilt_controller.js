import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    angle:       { type: Number, default: 76 },
    perspective: { type: Number, default: 320 },
    scale:       { type: Number, default: 1.12 },
    return:      { type: Number, default: 600 },
    rarity:      { type: String, default: "Common" }
  }

  connect() {
    this.element.style.willChange = "transform"
    this.element.style.display = "inline-block"
    this.onMove  = this._onMove.bind(this)
    this.onLeave = this._onLeave.bind(this)
    this.element.addEventListener("mousemove", this.onMove)
    this.element.addEventListener("mouseleave", this.onLeave)
  }

  disconnect() {
    this.element.removeEventListener("mousemove", this.onMove)
    this.element.removeEventListener("mouseleave", this.onLeave)
  }

  // Devuelve el tipo de efecto según rareza
  get _effect() {
    switch (this.rarityValue) {
      case "Rare Holo":
      case "Promo":     return "holo"
      case "Rare":
      case "Uncommon":  return "silver"
      default:          return "common"   // Common
    }
  }

  _onMove(e) {
    const r  = this.element.getBoundingClientRect()
    const x  = (e.clientX - r.left) / r.width
    const y  = (e.clientY - r.top)  / r.height
    const rx = (y - 0.5) * -this.angleValue
    const ry = (x - 0.5) *  this.angleValue

    this.element.style.transform =
      `perspective(${this.perspectiveValue}px) rotateX(${rx}deg) rotateY(${ry}deg) scale(${this.scaleValue})`
    this.element.style.transition = "transform 0.07s ease-out"

    this._applyShine(x, y, ry)
  }

  _onLeave() {
    this.element.style.transform =
      `perspective(${this.perspectiveValue}px) rotateX(0) rotateY(0) scale(1)`
    this.element.style.transition =
      `transform ${this.returnValue}ms cubic-bezier(0.23, 1, 0.32, 1)`

    this._clearShine()
  }

  _applyShine(x, y, ry) {
    const shine   = this.element.querySelector(".card-shine")
    const rainbow = this.element.querySelector(".card-rainbow")
    const glitter = this.element.querySelector(".card-glitter")
    const sheen   = this.element.querySelector(".card-sheen")

    switch (this._effect) {

      case "holo":
        if (rainbow) {
          rainbow.style.opacity = "1"
          rainbow.style.backgroundPosition = `${x * 100}% ${y * 100}%`
          rainbow.style.filter = `hue-rotate(${Math.round(x * 360)}deg)`
        }
        if (glitter) {
          glitter.style.opacity = "0.5"
          glitter.style.backgroundPosition =
            `${x*60}px ${y*60}px, ${x*40}px ${y*40}px, ${x*80}px ${y*80}px`
        }
        if (shine) {
          shine.style.opacity = "1"
          shine.style.background =
            `radial-gradient(ellipse at ${x*100}% ${y*100}%, rgba(255,255,255,0.35) 0%, transparent 60%)`
        }
        break

      case "silver":
        if (sheen) {
          const band = x * 100
          sheen.style.opacity = "0.9"
          sheen.style.background = `
            linear-gradient(
              ${105 + ry}deg,
              transparent 0%,
              rgba(180,200,220,0.05) ${band - 30}%,
              rgba(210,225,240,0.45) ${band - 8}%,
              rgba(240,248,255,0.80) ${band}%,
              rgba(210,225,240,0.45) ${band + 8}%,
              rgba(180,200,220,0.05) ${band + 30}%,
              transparent 100%
            )`
        }
        if (shine) {
          shine.style.opacity = "0.45"
          shine.style.background =
            `radial-gradient(circle at ${x*100}% ${y*100}%, rgba(200,225,255,0.45) 0%, transparent 55%)`
        }
        break

      case "common":
      default:
        if (shine) {
          shine.style.opacity = "1"
          shine.style.background =
            `radial-gradient(circle at ${x*100}% ${y*100}%, rgba(255,255,255,0.28) 0%, transparent 55%)`
        }
        break
    }
  }

  _clearShine() {
    const shine   = this.element.querySelector(".card-shine")
    const rainbow = this.element.querySelector(".card-rainbow")
    const glitter = this.element.querySelector(".card-glitter")
    const sheen   = this.element.querySelector(".card-sheen")
    ;[shine, rainbow, glitter, sheen].forEach(el => {
      if (el) el.style.opacity = "0"
    })
  }
}