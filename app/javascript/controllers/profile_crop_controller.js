import { Controller } from "@hotwired/stimulus"
import Cropper from "cropperjs"

export default class extends Controller {
  static targets = ["input", "preview", "image", "dropzone", "form"]

  connect() {
    this.cropper = null
  }

  // Al seleccionar un archivo manualmente
  selectFile(event) {
    const file = event.target.files[0]
    if (file) {
      this.loadFile(file)
    }
  }

  // Manejo de Drag & Drop
  dragOver(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add("drag-over")
  }

  dragLeave(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("drag-over")
  }

  drop(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("drag-over")
    const file = event.dataTransfer.files[0]
    if (file) {
      this.inputTarget.files = event.dataTransfer.files
      this.loadFile(file)
    }
  }

  loadFile(file) {
    const reader = new FileReader()
    reader.onload = (e) => {
      this.imageTarget.src = e.target.result
      this.previewTarget.style.display = "flex"
      
      if (this.cropper) {
        this.cropper.destroy()
      }

      this.cropper = new Cropper(this.imageTarget, {
        aspectRatio: 1, // Cuadrado
        viewMode: 1,
        dragMode: 'move', // Permite arrastrar la imagen para ajustarla
        guides: false,
        center: false,
        highlight: false,
        cropBoxMovable: false,
        cropBoxResizable: false,
        toggleDragModeOnDblclick: false,
        autoCropArea: 1,
        responsive: true
      })
    }
    reader.readAsDataURL(file)
  }

  zoomIn() {
    if (this.cropper) this.cropper.zoom(0.1)
  }

  zoomOut() {
    if (this.cropper) this.cropper.zoom(-0.1)
  }

  cancel() {
    this.previewTarget.style.display = "none"
    this.inputTarget.value = "" // Reseteamos el input
    if (this.cropper) {
      this.cropper.destroy()
      this.cropper = null
    }
  }

  confirm() {
    // Cerramos el modal, el recorte se procesará al hacer submit del formulario
    this.previewTarget.style.display = "none"
  }

  // Antes de enviar el formulario, recortamos
  submit(event) {
    if (!this.cropper) return

    event.preventDefault()
    
    this.cropper.getCroppedCanvas({
      width: 500,
      height: 500
    }).toBlob((blob) => {
      const file = new File([blob], "profile_picture.jpg", { type: "image/jpeg" })
      
      const dataTransfer = new DataTransfer()
      dataTransfer.items.add(file)
      this.inputTarget.files = dataTransfer.files

      // Desactivamos el controlador para el siguiente submit
      this.cropper = null
      this.formTarget.submit()
    }, "image/jpeg")
  }
}
