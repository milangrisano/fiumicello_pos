$images = @{
    "tagliatelle_tartufo.jpg" = "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=500&q=80"
    "carbonara.jpg" = "https://images.unsplash.com/photo-1612874742237-6526221588e3?w=500&q=80"
    "orecchiette.jpg" = "https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=500&q=80"
    "gnocchi.jpg" = "https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=500&q=80"
    "pappardelle.jpg" = "https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=500&q=80"
    "risotto_funghi.jpg" = "https://images.unsplash.com/photo-1633504581786-316c8002b1b9?w=500&q=80"
    "linguine_scoglio.jpg" = "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&q=80"
    "agnolotti.jpg" = "https://images.unsplash.com/photo-1608897013039-887f21d8c804?w=500&q=80"
    "bucatini.jpg" = "https://images.unsplash.com/photo-1626844131082-256783844137?w=500&q=80"
    "ravioli.jpg" = "https://images.unsplash.com/photo-1587740908075-9e245070dfaa?w=500&q=80"
    "spaghetti_cacio.jpg" = "https://images.unsplash.com/photo-1595295333158-4742f28fbd85?w=500&q=80"
    "lasagna.jpg" = "https://images.unsplash.com/photo-1619895092538-128341789043?w=500&q=80"
    "osso_buco.jpg" = "https://images.unsplash.com/photo-1621845199672-002166946ce7?w=500&q=80"
    "filetto_manzo.jpg" = "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80"
    "branzino.jpg" = "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500&q=80"
    "cotoletta.jpg" = "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80"
    "bruschetta.jpg" = "https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?w=500&q=80"
    "carpaccio.jpg" = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80"
    "patate.jpg" = "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=500&q=80"
    "verdure.jpg" = "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=500&q=80"
    "tiramisu.jpg" = "https://images.unsplash.com/photo-1571877227200-a0d98eaa60f5?w=500&q=80"
    "panna_cotta.jpg" = "https://images.unsplash.com/photo-1541783245831-57d6fb0926d3?w=500&q=80"
}

$destDir = "c:\Users\milan\Documents\dev\fiumicello_app\assets\images\product"
if (!(Test-Path $destDir)) {
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
}

foreach ($key in $images.Keys) {
    $url = $images[$key]
    $filepath = Join-Path $destDir $key
    if (-Not (Test-Path $filepath)) {
        Write-Host "Downloading $key..."
        Invoke-WebRequest -Uri $url -OutFile $filepath
    } else {
        Write-Host "Skipping $key, already exists."
    }
}
Write-Host "All images downloaded."
