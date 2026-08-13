# create_metafields.ps1

# $env:SHOPIFY_STORE and $env:SHOPIFY_TOKEN must be set in the PowerShell session
$store = $env:SHOPIFY_STORE
$token = $env:SHOPIFY_TOKEN
if (-not $store -or -not $token) {
  Write-Error "Please set SHOPIFY_STORE and SHOPIFY_TOKEN environment variables in this PowerShell session."
  exit 1
}

$api = "https://$store/admin/api/2024-10/graphql.json"

$payload = @'
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
'@

$body = @{ query = $payload } | ConvertTo-Json -Depth 10
try {
  $resp = Invoke-RestMethod -Uri $api -Method Post -Headers @{ 'X-Shopify-Access-Token' = $token } -Body $body -ContentType 'application/json'
  $resp | ConvertTo-Json -Depth 10
} catch {
  Write-Error "Request failed: $_"
}

Write-Output "Done. Check responses for userErrors."
