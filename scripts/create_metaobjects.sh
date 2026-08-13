#!/usr/bin/env bash
# Creates the `review` and `combo` metaobject definitions via the Admin GraphQL API.
# Requires SHOPIFY_STORE (shop domain without https, eg: my-shop.myshopify.com)
# and SHOPIFY_TOKEN (private app or Admin API access token) in the environment.

API_URL="https://${SHOPIFY_STORE}/admin/api/2024-10/graphql.json"

if [ -z "$SHOPIFY_STORE" ] || [ -z "$SHOPIFY_TOKEN" ]; then
  echo "Please set SHOPIFY_STORE and SHOPIFY_TOKEN environment variables."
  exit 1
fi

curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "X-Shopify-Access-Token: $SHOPIFY_TOKEN" \
  -d '{"query":"mutation CreateReviewDefinition { metaobjectDefinitionCreate(definition: { type: \"review\" name: \"Review\" fieldDefinitions: [ { key: \"rating\", name: \"Rating\", type: \"number_integer\", required: true } { key: \"title\", name: \"Title\", type: \"single_line_text_field\", required: true } { key: \"quote\", name: \"Quote\", type: \"multi_line_text_field\", required: true } { key: \"author_name\", name: \"Author name\", type: \"single_line_text_field\", required: true } { key: \"author_context\", name: \"Author context\", type: \"single_line_text_field\" } ] }) { metaobjectDefinition { id type } userErrors { field message } } }"}' | jq .

curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "X-Shopify-Access-Token: $SHOPIFY_TOKEN" \
  -d '{"query":"mutation CreateComboDefinition { metaobjectDefinitionCreate(definition: { type: \"combo\" name: \"Combo\" fieldDefinitions: [ { key: \"title\", name: \"Title\", type: \"single_line_text_field\", required: true } { key: \"flag\", name: \"Flag\", type: \"single_line_text_field\" } { key: \"products\", name: \"Products\", type: \"list.product_reference\", required: true } { key: \"description\", name: \"Description\", type: \"multi_line_text_field\", required: true } { key: \"featured\", name: \"Featured\", type: \"boolean\" } ] }) { metaobjectDefinition { id type } userErrors { field message } } }"}' | jq .

echo "Done. Check responses above for any userErrors."
