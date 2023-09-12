import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="parallax"
export default class extends Controller {
  static targets = ["text", "leaf", "hill1", "hill4", "hill5"]
  connect() {
    console.log("Hello from the_other_side_controller.js")
    console.log(this.sidebarTarget)
  }
}

// let text = document.getElementById('text');
// let leafhill = document.getElementById('leafhill');
// let hill1 = document.getElementById('hill1');
// let hill4 = document.getElementById('hill4');
// let hill5 = document.getElementById('hill5');


// window.addEventListener('scroll', () => {
//   console.log('Hello');
//   let value = window.scrollY;

//   text.style.marginTop = value * 2.5 + 'px';
//   leaf.style.top = value * -1.5 + 'px';
//   leaf.style.left = value * 1.5 + 'px';
//   hill5.style.left = value * 1.5 + 'px';
//   hill4.style.left = value * -1.5 + 'px';
//   hill1.style.top = value * 1.5 + 'px';

// })
