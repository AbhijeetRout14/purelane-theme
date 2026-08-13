# seed_metaobjects.ps1

# $env:SHOPIFY_STORE, $env:SHOPIFY_TOKEN are required.
# Optionally set $env:PRODUCT_GIDS to a JSON array string of product GIDs for combo products,
# e.g. $env:PRODUCT_GIDS='["gid://shopify/Product/123","gid://shopify/Product/456","gid://shopify/Product/789"]'

$store = $env:SHOPIFY_STORE
$token = $env:SHOPIFY_TOKEN
if (-not $store -or -not $token) {
  Write-Error "Please set SHOPIFY_STORE and SHOPIFY_TOKEN environment variables in this PowerShell session."
  exit 1
}

$api = "https://$store/admin/api/2024-10/graphql.json"

# Seed one review entry
$review = @'
mutation {
  metaobjectCreate(input: {type: "review", fields: [ {key: "rating", value: "5"}, {key: "title", value: "Amazing!"}, {key: "quote", value: "This product changed my kitchen."}, {key: "author_name", value: "Sam"}, {key: "author_context", value: "Verified buyer"} ] }) {
    metaobject { id }
    userErrors { field message }
  }
}
'@

$body = @{ query = $review } | ConvertTo-Json -Depth 10
try {
  $resp = Invoke-RestMethod -Uri $api -Method Post -Headers @{ 'X-Shopify-Access-Token' = $token } -Body $body -ContentType 'application/json'
  $resp | ConvertTo-Json -Depth 10
} catch {
  Write-Error "Request failed: $_"
}

# Seed one combo entry using $env:PRODUCT_GIDS if provided
if ($env:PRODUCT_GIDS) {
  $productJson = $env:PRODUCT_GIDS
  $comboTemplate = @"mutation {
  metaobjectCreate(input: {type: \"combo\", fields: [ {key: \"title\", value: \"Kitchen essentials\"}, {key: \"flag\", value: \"Most popular\"}, {key: \"products\", value: \"$productJson\"}, {key: \"description\", value: \"Includes: Foaming Kitchen Cleaner, Dishwash Gel & Tap Cleaner.\"}, {key: \"featured\", value: \"false\"} ] }) {
    metaobject { id }
    userErrors { field message }
  }
}"
  $body = @{ query = $comboTemplate } | ConvertTo-Json -Depth 10
  try {
    $resp = Invoke-RestMethod -Uri $api -Method Post -Headers @{ 'X-Shopify-Access-Token' = $token } -Body $body -ContentType 'application/json'
    $resp | ConvertTo-Json -Depth 10
  } catch {
    Write-Error "Request failed: $_"
  }
} else {
  Write-Warning "PRODUCT_GIDS not set. Edit this script or set PRODUCT_GIDS env var to seed combo product references. Example:
$env:PRODUCT_GIDS='["gid://shopify/Product/123","gid://shopify/Product/456","gid://shopify/Product/789"]'"
}

Write-Output "Seeding complete. Check responses above for created IDs and any userErrors."
