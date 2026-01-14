param([switch]$local)

if ($local) {
    deppth2 hpk -c BC7 -s .\textures\portraits -t .\data\zerp-MelSkinPortraits
}
deppth2 hpk -c BC7 -s .\textures\skins -t .\data\zerp-MelSkin

mkdir data/Custom -force
cp data/None.png data/Custom/custom.png
deppth2 hpk -s .\data\Custom -t .\data\zerp-MelSkinCustom

python ./resize.py
mkdir data/small -force
deppth2 hpk -s .\textures\skins-small -t .\data\small\zerp-MelSkin
deppth2 hpk -s .\data\Custom -t .\data\small\zerp-MelSkinCustom
cp .\data\small\zerp-MelSkin.pkg .\data\zerp-MelSkinSmall.pkg
cp .\data\small\zerp-MelSkin.pkg_manifest .\data\zerp-MelSkinSmall.pkg_manifest

cp .\data\small\zerp-MelSkinCustom.pkg .\data\zerp-MelSkinCustomSmall.pkg
cp .\data\small\zerp-MelSkinCustom.pkg_manifest .\data\zerp-MelSkinCustomSmall.pkg_manifest

rm -force -recurse data/zerp-MelSkin
rm -force -recurse data/zerp-MelSkinPortraits -ErrorAction SilentlyContinue  
rm -force -recurse data/zerp-MelSkinCustom
rm -force -recurse data/small
rm -force data/update -ErrorAction SilentlyContinue

tcli build