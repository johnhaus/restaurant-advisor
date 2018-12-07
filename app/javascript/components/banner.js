import Typed from 'typed.js';

function loadDynamicBannerText() {
  new Typed('#banner-typed-text', {
    strings: ["All the Restaurants.", "All in One Place."],
    typeSpeed: 50,
    loop: true
  });
}

export { loadDynamicBannerText };
