## Deploy & Setup Instructions

This project contains theme assets and helper scripts to create metaobjects and product metafields on your Shopify store. Several actions require Admin API credentials and must be run from your machine.

Prerequisites
- Install `shopify` CLI and authenticate: https://shopify.dev/themes/tools/cli
- Install `jq` for JSON pretty-printing in the scripts
- Export environment variables in your shell:

```bash
export SHOPIFY_STORE=my-shop.myshopify.com
export SHOPIFY_TOKEN=shpat_xxx_or_private_app_token
```

Local steps performed by the repo (already done):
- Merged `assets/`, `sections/`, `snippets/`, and `templates/index.json` into the theme folder.
- Added `snippets/purelane-head.liquid` and `snippets/purelane-footer.liquid`.
- Added a minimal `layout/theme.liquid` that renders the above snippets.

What you must run on your machine (scripted):

1) Create metaobject definitions (review + combo):

```bash
bash scripts/create_metaobjects.sh
```

2) Create product metafield definitions:

```bash
bash scripts/create_metafields.sh
```

3) Seed sample metaobjects (replace PRODUCT_GID placeholders in `scripts/seed_metaobjects.sh` with real product GIDs):

```bash
bash scripts/seed_metaobjects.sh
```

4) Pull your live/dev theme (optional) and push updated theme files to an unpublished dev theme:

```bash
shopify theme pull --theme=<live-theme-id>
shopify theme push --unpublished --theme=<dev-theme-id>
```

5) Open the Theme Editor and complete the manual steps:
- Create product metafield values for 8+ products (badge_label, rating, review_count)
- Create metaobject entries (if you prefer the Admin UI) or validate entries created via scripts
- In Theme Editor, configure `pl_reviews`, `pl_combos`, `pl_shop`, and `pl_hero` blocks as described in `metaobjects/setup.md`.

6) QA per-section using the testing checklist in `metaobjects/setup.md`.

Once you've verified the dev theme, publish it via the Shopify admin or `shopify theme publish --theme=<dev-theme-id>`.
