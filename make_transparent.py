import sys
from PIL import Image

def make_transparent(input_path, output_path):
    img = Image.open(input_path).convert("RGBA")
    datas = img.getdata()
    
    # We'll replace near-white (with high tolerance) at the corners with transparent.
    # To be safe and clean, we'll do a simple flood fill from 0,0, but Pillow doesn't have a direct RGBA floodfill to transparent.
    # We can just check if a pixel is white-ish, but the prompt generated an app logo. It probably has a solid dark blue rounded rectangle on a white square.
    # So we'll find the white pixels and make them transparent.
    new_data = []
    for item in datas:
        # Check if it's practically white
        if item[0] > 240 and item[1] > 240 and item[2] > 240:
            new_data.append((255, 255, 255, 0))
        else:
            new_data.append(item)
            
    img.putdata(new_data)
    img.save(output_path, "PNG")

if __name__ == "__main__":
    make_transparent("assets/images/app_logo.png", "assets/images/app_logo_transparent.png")
