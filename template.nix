with builtins;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with import ../helpers.nix;
let
  input = readFile ./sample.txt;
in
{
  res1 = input;
  res2 = input;
}
