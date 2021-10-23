import '@shoelace-style/shoelace/dist/themes/light.css';
import '@shoelace-style/shoelace/dist/components/alert/alert.js';
import '@shoelace-style/shoelace/dist/components/button/button.js';
import '@shoelace-style/shoelace/dist/components/dialog/dialog.js';
import '@shoelace-style/shoelace/dist/components/form/form.js';
import '@shoelace-style/shoelace/dist/components/icon/icon.js';
import '@shoelace-style/shoelace/dist/components/input/input.js';
import '@shoelace-style/shoelace/dist/components/progress-bar/progress-bar.js';
import { registerIconLibrary } from '@shoelace-style/shoelace/dist/utilities/icon-library.js';

import "index.css"

import "./stripe_payment.js.rb"

registerIconLibrary('remixicon', {
  resolver: name => {
    const match = name.match(/^(.*?)\/(.*?)(-(fill))?$/);
    match[1] = match[1].charAt(0).toUpperCase() + match[1].slice(1);
    return `https://cdn.jsdelivr.net/npm/remixicon@2.5.0/icons/${match[1]}/${match[2]}${match[3] || '-line'}.svg`;
  },
  mutator: svg => svg.setAttribute('fill', 'currentColor')
});

const setupTestimonials = () => {
  const animated = document.querySelectorAll('testimonials-list li')

  animated.forEach(el => {
    el.addEventListener('animationend', (e) => {
      setTimeout(() => {
        e.target.style.animation = ""
        let nextEl = e.target.nextElementSibling
        if (!nextEl) nextEl = document.querySelector('testimonials-list li')
        //console.log("setting nextEl!", nextEl)
        nextEl.style.animation = "fadeInOut ease 6s"
      }, 100)
    })
  })

  setTimeout(() => {
    animated[0].style.animation = "fadeInOut ease 6s"
  }, 1000)
}

window.addEventListener("DOMContentLoaded", () => {
  const dialog = document.querySelector("sl-dialog#donation")
  const closeButton = dialog.querySelector("sl-button[slot='footer']")

  closeButton.addEventListener("click", () => dialog.hide())

  document.querySelectorAll("sl-button[data-open-donate]").forEach(item => {
    item.addEventListener("click", () => {
      dialog.show()
    })
  })

  dialog.querySelector("sl-form").addEventListener("sl-submit", () => {
    dialog.querySelector("section#payment-options").hidden = true
    dialog.querySelector("sl-button[slot='footer'").remove()
    dialog.querySelector("section#stripe-payment-details").hidden = false
    const amount = dialog.querySelector("#contribution-amount").value
    dialog.querySelector("stripe-payment").display(amount)
  })

  setupTestimonials()
})
