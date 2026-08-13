#!/usr/bin/env bash
# Seed sample metaobject entries (reviews + combos). Replace PRODUCT_GID placeholders
# with actual product GraphQL IDs for product references in combos.

API_URL="https://${SHOPIFY_STORE}/admin/api/2024-10/graphql.json"

if [ -z "$SHOPIFY_STORE" ] || [ -z "$SHOPIFY_TOKEN" ]; then
  echo "Please set SHOPIFY_STORE and SHOPIFY_TOKEN environment variables."
  exit 1
fi

echo "Seeding one sample review and one sample combo (modify script to add more)."

read -r -d '' REVIEW <<'GRAPHQL'
mutation {
  metaobjectCreate(input: {type: "review", fields: [ {key: "rating", value: "5"}, {key: "title", value: "Amazing!"}, {key: "quote", value: "This product changed my kitchen."}, {key: "author_name", value: "Sam"}, {key: "author_context", value: "Verified buyer"} ] }) {
    metaobject { id }
    userErrors { field message }
  }
}
GRAPHQL

curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "X-Shopify-Access-Token: $SHOPIFY_TOKEN" \
  -d "{\"query\":$(jq -Rsa . <<< "$REVIEW") }" | jq .

read -r -d '' COMBO <<'GRAPHQL'
mutation {
  metaobjectCreate(input: {type: "combo", fields: [ {key: "title", value: "Kitchen essentials"}, {key: "flag", value: "Most popular"}, {key: "products", value: "[\"PRODUCT_GID_1\",\"PRODUCT_GID_2\",\"PRODUCT_GID_3\"]"}, {key: "description", value: "Includes: Foaming Kitchen Cleaner, Dishwash Gel & Tap Cleaner."}, {key: "featured", value: "false"} ] }) {
    metaobject { id }
    userErrors { field message }
  }
}
GRAPHQL

curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "X-Shopify-Access-Token: $SHOPIFY_TOKEN" \
  -d "{\"query\":$(jq -Rsa . <<< "$COMBO") }" | jq .

echo "Seed complete (check responses for userErrors and the created metaobject ids)."
