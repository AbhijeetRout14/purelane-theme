# Purelane homepage — Shopify build

Five sections from `purelane-homepage.html` rebuilt as production Dawn sections:
hero, reviews marquee, best-selling combos, bundles, shop grid.

## Folder structure

```
sections/
  hero.liquid              — heading/lede/CTAs settings, up to 4 badge blocks
  reviews-marquee.liquid   — blocks reference `review` metaobjects
  combos.liquid            — blocks reference `combo` metaobjects
  bundles.liquid           — 3 tier blocks, plain settings (not metaobjects — see notes)
  shop-grid.liquid         — collection + product limit, no blocks
snippets/
  product-card.liquid      — shared by shop-grid.liquid and combos.liquid's product tray
  price.liquid             — money/compare-at/discount, real Shopify data only
  icon.liquid               — svg lookup, replaces ~30 hand-inlined duplicate icons
assets/
  purelane-sections.css     — all styling, every selector prefixed .pl- / --pl-
  purelane-reveal.js        — reveal-on-scroll, progressive enhancement only
  purelane-hero.js          — optional multi-image hero carousel upgrade
  purelane-reviews.js       — builds the aria-hidden marquee clone (fixes source bug)
templates/
  index.json                — wires all 5 sections onto the homepage in order
metaobjects/
  setup.md                   — field definitions + GraphQL mutations to create them
```

## Install into your dev store

1. **Copy files in.** Using Shopify CLI: `shopify theme push` from a checkout that
   has these `sections/`, `snippets/`, `assets/`, `templates/` folders merged into
   your Dawn theme directory (they're new files, nothing here overwrites Dawn's
   own files — no naming collisions were used on purpose).
2. **Load the shared CSS/JS once**, in `layout/theme.liquid`, rather than per
   section (avoids duplicate `<link>`/`<script>` tags if a section is duplicated
   on the page):
   ```liquid
   {{ 'purelane-sections.css' | asset_url | stylesheet_tag }}
   ```
   before `</head>`, and:
   ```liquid
   {{ 'purelane-reveal.js' | asset_url | script_tag: defer: true }}
   {{ 'purelane-hero.js' | asset_url | script_tag: defer: true }}
   {{ 'purelane-reviews.js' | asset_url | script_tag: defer: true }}
   ```
   before `</body>`.
3. **Create the metaobject definitions** — `review` and `combo` — following
   `metaobjects/setup.md`. Do this before touching the theme editor for the
   reviews/combos sections, or their block settings will have nothing to
   reference.
4. **Enter metaobject entries** — add 6–8 `review` entries and 4–5 `combo`
   entries via Content → Metaobjects, using the source file's copy as a
   starting point (sample data included in `setup.md`).
5. **Create the product metafields** (`custom.badge_label`, `custom.rating`,
   `custom.review_count`) per `setup.md`, and set values on your 8+ seeded
   products.
6. **Open the theme editor**, go to the homepage, and on `pl_reviews` /
   `pl_combos` add one block per metaobject entry (the `templates/index.json`
   here ships those two sections with empty block lists since the metaobject
   IDs don't exist until you create them in your store). On `pl_shop`, pick
   your collection in the section settings — same reason, it's a
   store-specific resource reference that can't be pre-filled.

## What I deliberately left out of scope

- The full-page scrolling "scene" background (colour crossfade + animated
  water/bubble SVG layers) is page-wide chrome, not part of the five required
  sections — flagged in the brief as bonus. The five sections keep the glass/
  typography look but sit on Dawn's normal background.
- The hero's 1→2→3 product rotating stage ships as a static image by default;
  `purelane-hero.js` will upgrade it into a rotating carousel automatically if
  you extend `hero.liquid` with multiple image blocks — documented as the next
  step rather than built out, to protect time for the other four sections.

## Testing checklist (do this per section before moving to the next)

- [ ] Add the section fresh from the block picker — renders with sensible defaults
- [ ] Duplicate the section — no id collisions, both instances animate independently
- [ ] Add/remove/reorder blocks live in the editor — nothing breaks or throws
- [ ] Resize to 375px — no horizontal scroll, no overlap
- [ ] Tab through with keyboard only — visible focus rings throughout
- [ ] Toggle `prefers-reduced-motion` in devtools — animations stop, content still fully visible
- [ ] View a sold-out product, a product with no image, and a long-titled product in the shop grid
- [ ] Lighthouse / PageSpeed pass with images lazy-loaded and no console errors
