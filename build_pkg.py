from pkg_builder import build_standalone_pkg
import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("-s", type=str, required=True)
parser.add_argument("-t", type=str, required=True)

args = parser.parse_args()
source_path = args.s
target_path = args.t

print(source_path, target_path)

pkg_textures = []

pkg_path = target_path + ".pkg"
pkg_manifest_path = pkg_path + '_manifest'

prefix = target_path.split("\\")[-1]

tex_list = os.listdir(source_path)

for tex in tex_list:
    if tex[-4:] == ".png":
        pkg_textures.append({
            'name': f"{prefix}\\" + tex[:-4],
            'png_path': os.path.abspath(source_path + "/" + tex),
            'width': 512,
            'height': 512,
            'fmt': 0x1C,
            'mip_count': 6,
        })

build_standalone_pkg(pkg_textures, pkg_path)