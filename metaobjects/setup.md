# Metaobject setup

Metaobject **definitions** live on the store, not in the theme repo, so they can't
be "installed" by pushing theme code — create them once before the `combos.liquid`
and `reviews-marquee.liquid` sections will have anything to reference.

Fastest path: **Settings → Custom data → Metaobjects → Add definition**, using the
fields below. Or run the GraphQL mutations further down via `shopify app` / the
GraphiQL Admin API explorer if you'd rather script it.

---

## `review`

| Field | Key | Type | Required |
|---|---|---|---|
| Rating | `rating` | Number (integer) | yes |
| Title | `title` | Single line text | yes |
| Quote | `quote` | Multi line text | yes |
| Author name | `author_name` | Single line text | yes |
| Author context | `author_context` | Single line text | no |

## `combo`

| Field | Key | Type | Required |
|---|---|---|---|
| Title | `title` | Single line text | yes |
| Flag | `flag` | Single line text | no |
| Products | `products` | List of product references (2–3) | yes |
| Description | `description` | Multi line text | yes |
| Featured | `featured` | True/false | no |

---

## GraphQL — create both definitions via Admin API

```graphql
mutation CreateReviewDefinition {
  metaobjectDefinitionCreate(definition: {
    type: "review"
    name: "Review"
    fieldDefinitions: [
      { key: "rating", name: "Rating", type: "number_integer", required: true }
      { key: "title", name: "Title", type: "single_line_text_field", required: true }
      { key: "quote", name: "Quote", type: "multi_line_text_field", required: true }
      { key: "author_name", name: "Author name", type: "single_line_text_field", required: true }
      { key: "author_context", name: "Author context", type: "single_line_text_field" }
    ]
  }) {
    metaobjectDefinition { id type }
    userErrors { field message }
  }
}

mutation CreateComboDefinition {
  metaobjectDefinitionCreate(definition: {
    type: "combo"
    name: "Combo"
    fieldDefinitions: [
      { key: "title", name: "Title", type: "single_line_text_field", required: true }
      { key: "flag", name: "Flag", type: "single_line_text_field" }
      { key: "products", name: "Products", type: "list.product_reference", required: true }
      { key: "description", name: "Description", type: "multi_line_text_field", required: true }
      { key: "featured", name: "Featured", type: "boolean" }
    ]
  }) {
    metaobjectDefinition { id type }
    userErrors { field message }
  }
}
```

## Product metafields (for shop-grid.liquid / product-card.liquid)

Also create these under **Settings → Custom data → Products**:

| Namespace.key | Type | Used for |
|---|---|---|
| `custom.badge_label` | Single line text | "Best seller" / "New" / "Top rated" pill |
| `custom.rating` | Decimal | Star rating shown on card |
| `custom.review_count` | Integer | Review count shown on card |

---

## Sample data to enter (matches the source content, for a quick first render)

**Combo 1** — Kitchen essentials — flag "Most popular" — products: Foaming Kitchen
Cleaner, Dishwash Gel, Tap Cleaner — description: "Includes: Foaming Kitchen
Cleaner, Dishwash Gel & Tap Cleaner. Everything for a sparkling kitchen, no need
to pick separately." — featured: false

**Combo 2** — Complete home bundle — flag "Best value" — products: Kitchen
Cleaner, Floor Cleaner, Handwash — description: "Includes: Kitchen Cleaner,
Laundry Detergent, Floor Cleaner, Toilet Cleaner & Handwash. Our biggest saving
box." — featured: true

Add 3–4 more combos and 6–8 reviews from the source file's copy to match the
original content volume.
