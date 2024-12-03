with builtins;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with import ../helpers.nix;
let
  input = map (x: map toInt (splitString "   " x)) (lines (readFile ./input.txt));
  left = sort lessThan (foldl' (acc: elem: acc ++ singleton (head elem)) [ ] input);
  right = sort lessThan (foldl' (acc: elem: acc ++ singleton (last elem)) [ ] input);
in
{
  res1 = foldl add 0 (zipListsWith (x: y: abs (x - y)) (right) (left));
  res2 = foldl (acc: elem: acc + ((x: x * (z: count (y: y == z) right) x) elem)) 0 left;
}
