set path "day$argv[1]"

echo $path
mkdir $path

touch $path/sample.txt
touch $path/input.txt
cp template.nix $path/default.nix
