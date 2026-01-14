from PIL import Image
import os

skins =  os.listdir("./textures/skins")
os.makedirs("./textures/skins-small", exist_ok = True)
print(skins)
for skin in skins:
    img = Image.open("./textures/skins/" + skin).resize((128,128))
    img.save("./textures/skins-small/" + skin)

img = Image.open("./data/None.png").resize((128,128))
img.save("./data/Custom/custom.png")