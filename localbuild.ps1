rm -force -recurse data/zerp-MelSkin
deppth2 hpk -c BC7 -s .\textures\ -t .\data\zerp-MelSkin
cp data/None.png data/Custom/custom.png
deppth2 hpk -s .\data\Custom -t .\data\zerp-MelSkinCustom
rm -force -recurse data/zerp-MelSkin
rm -force -recurse data/zerp-MelSkinCustom
tcli build