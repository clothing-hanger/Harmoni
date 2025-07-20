### @author: GuglioIsStupid, for use with Rit & Harmoni

from PIL import Image
import math
import sys, os, time

PADDING = 1  # 1px padding on all sides

class Node:
    def __init__(self, x, y, w, h):
        self.x = x
        self.y = y
        self.w = w
        self.h = h
        self.used = False
        self.down = None
        self.right = None

    def insert(self, img):
        iw, ih = img.size
        iw_padded = iw + PADDING
        ih_padded = ih + PADDING

        if self.used:
            return self.right.insert(img) or self.down.insert(img)
        elif iw_padded <= self.w and ih_padded <= self.h:
            self.used = True
            self.down = Node(self.x, self.y + ih_padded, self.w, self.h - ih_padded)
            self.right = Node(self.x + iw_padded, self.y, self.w - iw_padded, ih_padded)
            return Node(self.x, self.y, iw, ih)  # Only return usable (unpadded) area
        else:
            return None

def pack_images(images):
    sprites = [(Image.open(path), name) for path, name in images]
    sprites.sort(key=lambda x: x[0].height, reverse=True)

    total_area = sum((img.width + PADDING) * (img.height + PADDING) for img, _ in sprites)
    size = int(math.ceil(math.sqrt(total_area)))

    while True:
        root = Node(0, 0, size, size)
        positions = []

        success = True
        for img, name in sprites:
            node = root.insert(img)
            if node is None:
                success = False
                break
            positions.append((img, name, node.x, node.y))

        if success:
            break
        size = int(size * 1.1)

    return positions, size

def pack_spritesheet(images, output_image, output_txt):
    packed, sheet_size = pack_images(images)

    spritesheet = Image.new('RGBA', (sheet_size, sheet_size), (0, 0, 0, 0))
    max_x = max_y = 0

    with open(output_txt, 'w') as f:
        for img, name, x, y in packed:
            spritesheet.paste(img, (x, y))
            f.write(f"{name} {x}, {y}, {img.width}, {img.height}\n")
            max_x = max(max_x, x + img.width + PADDING)
            max_y = max(max_y, y + img.height + PADDING)

    # Safe crop: don't use getbbox()
    cropped = spritesheet.crop((0, 0, max_x, max_y))
    cropped.save(output_image)


if __name__ == "__main__":
    start_time = time.time()
    print("Packing sprites...")

    if len(sys.argv) < 2:
        print("Usage: python pack.py <folder_path> [output_filename]")
        sys.exit(1)

    folder_path = sys.argv[1]
    output_filename = sys.argv[2] if len(sys.argv) > 2 else "spritesheet"

    images = []
    for filename in os.listdir(folder_path):
        if filename.lower().endswith((".png", ".jpg", ".jpeg")):
            images.append((os.path.join(folder_path, filename), filename))

    if not images:
        print("No images found in the folder.")
        sys.exit(1)

    pack_spritesheet(images, f"{output_filename}.png", f"{output_filename}.txt")
    print(f"Packed {len(images)} images into {output_filename}.png and {output_filename}.txt in {time.time() - start_time:.2f} seconds.")
