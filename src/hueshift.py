from PIL import Image
import colorsys
import sys
import os
import argparse

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

def replace_pixels(base_img, input_img):
    if input_img == None :
        return base_img
    base_img.paste(input_img,mask = input_img)
    # base_img.show()
    # input_img.close()
    return base_img

def create_gradient(points):
    gmap = []
    points = sorted(points,key = lambda x:x[0])
    if points[0][0] != 0:
        points = [(0, 0, 0, 0)] + list(points) 
    if points[-1][0] != 255:
        points = list(points) + [(255,255,255,255)]
    last_pos, last_r, last_g, last_b = points[0]
    for pos, r, g, b in points[1:]:
        size = pos-last_pos
        rd = r-last_r
        gd = g-last_g
        bd = b-last_b
        for i in range(size):
            rn = int(last_r + i/size*rd)
            gn = int(last_g + i/size*gd)
            bn = int(last_b + i/size*bd)
            gmap.append((rn,gn,bn))
        last_pos, last_r, last_g, last_b = pos, r, g, b
    gmap.append((points[-1][1],points[-1][2],points[-1][3],))
    return gmap

def apply_gradient(image_path, gradient):
    with Image.open(image_path) as img:
        img = img.convert("RGBA")
        data = img.getdata()

        new_data = []
        for item in data:
            r, g, b, a = item
            grey = int((r+g+b)/3)
            r, g, b = gradient[grey]
            # print(gmap[grey])
            new_data.append((r,g,b,a))
        
        new_img = Image.new(img.mode, img.size)
        new_img.putdata(new_data)
        # new_img.show()
        return new_img

def gradient_map_hair(image_path, color):
    gmap = create_gradient([ (166,color[0],color[1],color[2])])
    return apply_gradient(image_path, gmap)

def gradient_map_dress(image_path, color):
    gmap = create_gradient([ (127,color[0],color[1],color[2]) ])
    return apply_gradient(image_path, gmap)

def rgb(string):
    return tuple([int(i.strip()) for i in string.split(",")])

# Usage

shifted_dress = None
shifted_hair = None

parser = argparse.ArgumentParser()
parser.add_argument("--path", type=str)
parser.add_argument("--dress", type=rgb)
parser.add_argument("--hair", type=rgb)

args = parser.parse_args()
input_folder = args.path
atlas_path = os.path.join(input_folder,"base.png")
dress_path = os.path.join(input_folder,"dress.png")
hair_path = os.path.join(input_folder,"hair.png")
dress_hue_path = os.path.join(input_folder,"dress_hue.png")
custom_path = os.path.join(input_folder,"Custom/custom.png")


if args.dress:
    shifted_dress = gradient_map_dress(dress_path, args.dress)

if args.hair:
    shifted_hair = gradient_map_hair(hair_path, args.hair)
# shifted.save(dress_hue_path)

img = Image.open(atlas_path)

new_dress = replace_pixels(img, shifted_dress)
new_hair = replace_pixels(new_dress, shifted_hair)
new_hair.show()
new_hair.save(custom_path)
