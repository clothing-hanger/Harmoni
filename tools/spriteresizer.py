### @author: GuglioIsStupid, for use with Rit & Harmoni

from PIL import Image
import math
import sys, os, time

# Resizes assets with a given multiplier. Can either be single image or a directory of images. No packing is done here.

def resize_image(image_path, multiplier):
    img = Image.open(image_path)
    new_size = (int(img.width * multiplier), int(img.height * multiplier))
    resized_img = img.resize(new_size, Image.LANCZOS)
    resized_img.save(image_path)
    print(f"Resized {image_path} to {new_size}")

def resize_directory(directory, multiplier):
    for filename in os.listdir(directory):
        if filename.endswith(('.png', '.jpg', '.jpeg')):
            image_path = os.path.join(directory, filename)
            resize_image(image_path, multiplier)

def main():
    if len(sys.argv) < 3:
        print("Usage: python spriteresizer.py <folder_path> <multiplier>")
        sys.exit(1)

    folder_path = sys.argv[1]
    multiplier = float(sys.argv[2])

    if not os.path.isdir(folder_path):
        print(f"Error: {folder_path} is not a valid directory.")
        sys.exit(1)

    start_time = time.time()
    resize_directory(folder_path, multiplier)
    end_time = time.time()

    print(f"Resizing completed in {end_time - start_time:.2f} seconds.")

if __name__ == "__main__":
    main()