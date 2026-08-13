/**
 * Purelane Reviews Marquee
 *
 * Keeps ONE marquee track in the DOM.
 * The review cards inside the track are duplicated for
 * a seamless horizontal loop.
 */
(function () {
  var reduce = window.matchMedia(
    '(prefers-reduced-motion: reduce)'
  ).matches;

  function initMarquee(track) {
    if (!track || track.dataset.plInitialized === 'true') return;

    var cards = Array.from(track.children);

    if (!cards.length) return;

    /*
     * Duplicate the review CARDS inside the same track.
     * Do not duplicate the entire track.
     */
    cards.forEach(function (card) {
      var clone = card.cloneNode(true);

      clone.setAttribute('aria-hidden', 'true');

      clone.querySelectorAll('[id]').forEach(function (el) {
        el.removeAttribute('id');
      });

      track.appendChild(clone);
    });

    track.dataset.plInitialized = 'true';

    /*
     * Calculate animation speed based on the width
     * of the original set of cards.
     */
    var originalWidth = cards.reduce(function (total, card) {
      return total + card.getBoundingClientRect().width;
    }, 0);

    var gap = parseFloat(
      window.getComputedStyle(track).gap
    ) || 0;

    var totalWidth = originalWidth + (cards.length - 1) * gap;

    var seconds = Math.max(
      24,
      Math.round(totalWidth / 40)
    );

    track
      .closest('.pl-scope')
      .style
      .setProperty('--pl-marq-dur', seconds + 's');

    /*
     * Reduced motion:
     * Don't animate.
     */
    if (reduce) {
      track.style.animation = 'none';
    }
  }

  function initAll() {
    document
      .querySelectorAll('[data-pl-revtrack]')
      .forEach(initMarquee);
  }

  initAll();

  /*
   * Shopify theme editor support.
   */
  document.addEventListener(
    'shopify:section:load',
    function (event) {
      var track = event.target.querySelector(
        '[data-pl-revtrack]'
      );

      if (track) {
        initMarquee(track);
      }
    }
  );
})();