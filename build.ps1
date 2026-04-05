param([switch]$local)

if ($local) {
    deppth2 hpk -c BC7 -s .\textures\portraits -t .\data\zerp-MelSkinPortraits
}
python build_pkg.py -s .\textures\skins -t .\data\zerp-MelSkin

mkdir data/Custom -force
cp data/None.png data/Custom/custom.png
python build_pkg.py -s .\data\Custom -t .\data\zerp-MelSkinCustom

rm -force -recurse data/zerp-MelSkinPortraits -ErrorAction SilentlyContinue

rm -force data/update -ErrorAction SilentlyContinue

tcli build