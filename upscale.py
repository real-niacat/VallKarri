from PIL import Image
input_path = "./assets/1x/assets.png"
output_path = "./assets/2x/assets.png"

img = Image.open(input_path)
scaled_img = img.resize((img.width * 2, img.height * 2), Image.NEAREST)
scaled_img.save(output_path)

print(f"Saved 2x image to {output_path}")
