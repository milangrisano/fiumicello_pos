import os
from PIL import Image

src = "/Users/macmini/.gemini/antigravity/brain/c0a9704b-1bee-417d-895e-543f37c3b6ec/logo_fiumicello_cream_1771996017725.png"
dst = "/Users/macmini/Documents/Flutter/fiumicello_app/assets/images/logo_fiumicello.png"

print("Opening original solid-cream image...")
img = Image.open(src).convert("RGBA")
img.thumbnail((800, 800), Image.LANCZOS)
width, height = img.size

pixels = img.load()

checker_count = 0

for y in range(height):
    for x in range(width):
        r, g, b, a = pixels[x, y]
        lum = 0.299 * r + 0.587 * g + 0.114 * b
        sat = max(r, g, b) - min(r, g, b)
        
        # If it's bright and grayscale/desaturated, it's either the cream background or the white hat
        # Both will be made completely transparent.
        if sat < 20 and lum > 230:
            pixels[x, y] = (0, 0, 0, 0)
        elif sat < 20 and lum > 50:
            # Semi-transparent for smooth edges of the black text
            alpha = max(0, min(255, int(255 * (230 - lum) / 180.0)))
            # Force the pixel color to black, but with transparency
            pixels[x, y] = (0, 0, 0, alpha)
        elif sat >= 20:
            # Leave colors intact (Italian flag)
            pixels[x, y] = (r, g, b, 255)
        else:
            # Thick black strokes
            pixels[x, y] = (0, 0, 0, 255)

img.save(dst, "PNG", optimize=True)
print("Saved perfect transparent logo to", dst)
