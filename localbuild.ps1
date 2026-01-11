rm -force -recurse data/zerp-MelSkin

deppth2 hpk -c BC7 -s .\textures\portraits -t .\data\zerp-MelSkinPortraits
deppth2 hpk -c BC7 -s .\textures\skins -t .\data\zerp-MelSkin

python ./resize.py
mkdir data/small -force
deppth2 hpk -s .\textures\skins-small -t .\data\small\zerp-MelSkin
cp .\data\small\zerp-MelSkin.pkg .\data\zerp-MelSkinSmall.pkg
cp .\data\small\zerp-MelSkin.pkg_manifest .\data\zerp-MelSkinSmall.pkg_manifest

mkdir data/Custom -force
cp data/None.png data/Custom/custom.png
deppth2 hpk -s .\data\Custom -t .\data\zerp-MelSkinCustom

rm -force -recurse data/zerp-MelSkin
rm -force -recurse data/zerp-MelSkinPortraits
rm -force -recurse data/zerp-MelSkinCustom
rm -force -recurse data/small

tcli build