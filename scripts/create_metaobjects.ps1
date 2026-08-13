# create_metaobjects.ps1

# $env:SHOPIFY_STORE and $env:SHOPIFY_TOKEN must be set in the PowerShell session
$store = $env:SHOPIFY_STORE
$token = $env:SHOPIFY_TOKEN
if (-not $store -or -not $token) {
  Write-Error "Please set SHOPIFY_STORE and SHOPIFY_TOKEN environment variables in this PowerShell session (example: $env:SHOPIFY_STORE=\"my-shop.myshopify.com\")."
  exit 1
}

$api = "https://$store/admin/api/2024-10/graphql.json"

$review = @'
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
  }) { metaobjectDefinition { id type } userErrors { field message } }
}
'@

$combo = @'
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
  }) { metaobjectDefinition { id type } userErrors { field message } }
}
'@

Function Post-GraphQL($query) {
  $body = @{ query = $query } | ConvertTo-Json -Depth 10
  try {
    $resp = Invoke-RestMethod -Uri $api -Method Post -Headers @{ 'X-Shopify-Access-Token' = $token } -Body $body -ContentType 'application/json'
    $resp | ConvertTo-Json -Depth 10
  } catch {
    Write-Error "Request failed: $_"
  }
}

Write-Output "Creating 'review' metaobject definition..."
Post-GraphQL $review

Write-Output "Creating 'combo' metaobject definition..."
Post-GraphQL $combo

Write-Output "Done. Review responses above for any userErrors."
