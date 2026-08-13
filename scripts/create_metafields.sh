#!/usr/bin/env bash
# Create product-level metafield definitions as described in metaobjects/setup.md
# Requires SHOPIFY_STORE and SHOPIFY_TOKEN environment variables.

API_URL="https://${SHOPIFY_STORE}/admin/api/2024-10/graphql.json"

if [ -z "$SHOPIFY_STORE" ] || [ -z "$SHOPIFY_TOKEN" ]; then
  echo "Please set SHOPIFY_STORE and SHOPIFY_TOKEN environment variables."
  exit 1
fi

read -r -d '' PAYLOAD <<'GRAPHQL'
mutation CreateProductMetafields {
  metafieldDefinitionCreate(definition: { 
    name: "Badge label", 
    namespace: "custom", 
    key: "badge_label", 
    type: "single_line_text_field",
    ownerType: PRODUCT
  }) { metafieldDefinition { id } userErrors { field message } }

  metafieldDefinitionCreate(definition: { 
    name: "Rating", 
    namespace: "custom", 
    key: "rating", 
    type: "number_decimal",
    ownerType: PRODUCT
  }) { metafieldDefinition { id } userErrors { field message } }

  metafieldDefinitionCreate(definition: { 
    name: "Review count", 
    namespace: "custom", 
    key: "review_count", 
    type: "number_integer",
    ownerType: PRODUCT
  }) { metafieldDefinition { id } userErrors { field message } }
}
GRAPHQL

curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "X-Shopify-Access-Token: $SHOPIFY_TOKEN" \
  -d "{\"query\":$(jq -Rsa . <<< "$PAYLOAD") }" | jq .

echo "Done. Check responses for userErrors."
