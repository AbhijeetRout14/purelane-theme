/**
 * assets/purelane-hero.js
 * Optional upgrade for the hero: if you add a second/third product image
 * block, this rotates between them with dot navigation, mirroring the
 * prototype's #hstage behaviour. Scoped to data-section-id so duplicating
 * the hero section in the theme editor never produces id collisions —
 * the source file queried #hstage/#hdots by literal id, which breaks the
 * instant a merchant duplicates the section.
 * Load with {{ 'purelane-hero.js' | asset_url | script_tag: defer: true }}
 */
(function () {
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  function initHero(root) {
    var slides = root.querySelectorAll('[data-pl-hslide]');
    var dots = root.querySelectorAll('[data-pl-hdots] button');
    if (slides.length < 2) return; // single image, nothing to rotate

    var i = 0, timer = null;

    function go(n) {
      i = (n + slides.length) % slides.length;
      slides.forEach(function (s, idx) { s.classList.toggle('pl-on', idx === i); });
      dots.forEach(function (d, idx) { d.classList.toggle('pl-on', idx === i); });
    }
    function play() { if (!timer && !reduce) timer = setInterval(function () { go(i + 1); }, 3800); }
    function stop() { if (timer) { clearInterval(timer); timer = null; } }

    dots.forEach(function (d, idx) {
      d.addEventListener('click', function () { stop(); go(idx); play(); });
    });
    root.addEventListener('mouseenter', stop);
    root.addEventListener('mouseleave', play);

    if ('IntersectionObserver' in window) {
      new IntersectionObserver(function (entries) {
        entries.forEach(function (e) { e.isIntersecting ? play() : stop(); });
      }, { threshold: 0.2 }).observe(root);
    } else {
      go(0);
    }
  }

  document.querySelectorAll('[data-pl-hero]').forEach(initHero);

  document.addEventListener('shopify:section:load', function (evt) {
    var hero = evt.target.querySelector('[data-pl-hero]');
    if (hero) initHero(hero);
  });
})();
