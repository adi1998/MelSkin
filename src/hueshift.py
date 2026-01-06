from PIL import Image
import colorsys
import sys
import os

def hue_shift(image_path, hue_shift=50):
    with Image.open(image_path) as img:
        # Convert image to RGB if it's not already
        img = img.convert('RGBA')
        
        # Get image data as a list of RGB tuples
        data = img.getdata()
        
        # Convert RGB to HSV, shift the hue, and convert back to RGB
        new_data = []
        for item in data:
            r, g, b, a = item
            h, s, v = colorsys.rgb_to_hsv(r/255., g/255., b/255.)
            h = (h + hue_shift/360) % 1
            r, g, b = colorsys.hsv_to_rgb(h, s, v)
            new_data.append((int(r*255), int(g*255), int(b*255), a))
        
        # Create a new image with the shifted colors
        new_img = Image.new(img.mode, img.size)
        new_img.putdata(new_data)
        
        # new_img.show()
        return new_img

def replace_pixels(base_path, input_img):
    base_img = Image.open(base_path)

    base_img.paste(input_img,mask = input_img)
    # base_img.show()
    input_img.close()
    return base_img

def gradient_map(image_path, color):
    gmap = [  ]
    for i in range(int(256*0.5)):
        gmap.append( tuple(map(lambda x:int(x*i/int(256*0.5-1)), color) ))
        # gmap.append( (i*color[0]/int(256*0.5-1), i*color[1]/int(256*0.5-1), i*color[2]/int(256*0.5-1)) )
    for i in range(int(256*0.5),256):
        gmap.append(color)
    with Image.open(image_path) as img:
        img = img.convert("RGBA")
        data = img.getdata()

        new_data = []
        for item in data:
            r, g, b, a = item
            grey = int((r+g+b)/3)
            r, g, b = gmap[grey]
            # print(gmap[grey])
            new_data.append((r,g,b,a))
        
        new_img = Image.new(img.mode, img.size)
        new_img.putdata(new_data)
        # new_img.show()
        return new_img


# Usage
input_folder = sys.argv[1]
atlas_path = os.path.join(input_folder,"base.png")
dress_path = os.path.join(input_folder,"dress.png")
dress_hue_path = os.path.join(input_folder,"dress_hue.png")
custom_path = os.path.join(input_folder,"Custom/custom.png")

shifted = None
if sys.argv[2] == "hue":
    shifted = hue_shift(dress_path, hue_shift=int(sys.argv[3]))
elif sys.argv[2] == "rgb":
    shifted = gradient_map(dress_path, (int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5])))

# shifted.save(dress_hue_path)

new_dress = replace_pixels(atlas_path, shifted)
new_dress.save(custom_path)
