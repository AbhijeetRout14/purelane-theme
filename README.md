# Purelane Shopify Theme

## Assignment Implementation

Rebuilt the five required homepage sections from the supplied Purelane
design:

1. Hero
2. Shop / Product Grid
3. Best-selling Combos
4. Bundles
5. Reviews Rail

The theme is implemented on Shopify using Liquid sections, section blocks,
Shopify product/collection data, metaobjects, and metafields.

## Shopify Data Model

### Review Metaobject

| Field | Key | Type | Required |
|---|---|---|---|
| Rating | `rating` | Integer | Yes |
| Title | `title` | Single-line text | Yes |
| Quote | `quote` | Multi-line text | Yes |
| Author name | `author_name` | Single-line text | Yes |
| Author context | `author_context` | Single-line text | No |

### Combo Metaobject

| Field | Key | Type | Required |
|---|---|---|---|
| Title | `title` | Single-line text | Yes |
| Flag | `flag` | Single-line text | No |
| Products | `products` | Product references | Yes |
| Description | `description` | Multi-line text | Yes |
| Featured | `featured` | Boolean | No |

### Product Metafields

- `custom.badge_label` — Single-line text
- `custom.rating` — Decimal
- `custom.review_count` — Integer

## Build Notes

The implementation reproduces the five required sections from the supplied
design while keeping the content merchant-editable through Shopify's theme
editor.

Product information, prices, collections and product references are sourced
from Shopify rather than hardcoded into the Liquid templates.

The Reviews Rail was implemented differently from the prototype's duplicated
DOM approach. The accessible review cards are rendered once, while JavaScript
duplicates the cards inside the same horizontal track to create the continuous
visual marquee. This avoids unnecessary duplicate content for screen readers.

The theme also includes responsive behavior, keyboard focus states and a
reduced-motion fallback.

A cart section was added so the normal Shopify cart and native checkout flow
can be used from the product experience.

## What I Would Improve With More Time

- Additional cross-browser testing
- More extensive Lighthouse/Core Web Vitals testing
- Further optimization of image loading and asset delivery
- More edge-case testing for sold-out products and unusual product titles
- Additional testing of theme-editor section duplication/reordering
- Further refinement of the mobile layout and interaction details

## AI Workflow

AI was used as a development assistant for translating the supplied visual
prototype into Shopify Liquid, CSS, JavaScript and section schemas.

I used AI for repetitive implementation, debugging Shopify Theme Check errors,
and troubleshooting theme-editor behavior.

I reviewed and tested the generated implementation in the Shopify development
store rather than treating generated code as final.

One example was the Reviews Marquee. The initial implementation duplicated the
complete review track, which produced two visible rows. I identified the issue
and changed the implementation so the review cards are duplicated inside a
single horizontal track, producing one continuously moving marquee.

For a larger number of similar builds, I would systematize reusable card
components, Shopify schema generation, Theme Check validation, responsive
testing and accessibility checks.
