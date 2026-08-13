/**
 * assets/purelane-reveal.js
 * Progressive-enhancement reveal-on-scroll for any .pl-rv element.
 * Content is fully visible without this script (see .pl-rv base styles) —
 * this only ADDS the fade/rise transition, gated by reduced-motion.
 * Load with {{ 'purelane-reveal.js' | asset_url | script_tag: defer: true }}
 */
(function () {
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  document.querySelectorAll('.pl-scope').forEach(function (scope) {
    scope.classList.add('pl-js');
  });
  if (reduce || !('IntersectionObserver' in window)) return;

  var io = new IntersectionObserver(
    function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('pl-in');
          io.unobserve(entry.target);
        }
      });
    },
    { rootMargin: '0px 0px -10% 0px', threshold: 0.12 }
  );

  document.querySelectorAll('.pl-rv').forEach(function (el) {
    io.observe(el);
  });

  // Re-observe elements added when a merchant adds/reorders blocks live in the editor.
  document.addEventListener('shopify:section:load', function (evt) {
    evt.target.querySelectorAll('.pl-rv').forEach(function (el) {
      el.classList.remove('pl-in');
      io.observe(el);
    });
  });
})();
