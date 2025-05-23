import os
from PIL import Image

input_dir = "./assets/1x/"
output_dir = "./assets/2x/"

os.makedirs(output_dir, exist_ok=True)

for filename in os.listdir(input_dir):
    if filename.endswith(".png"):
        input_path = os.path.join(input_dir, filename)
        output_path = os.path.join(output_dir, filename)

        img = Image.open(input_path)
        scaled_img = img.resize((img.width * 2, img.height * 2), Image.NEAREST)
        scaled_img.save(output_path)

        print(f"Saved 2x image to {output_path}")
