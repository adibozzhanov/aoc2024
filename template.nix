with builtins;
with import ../helpers.nix;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with (import <nixpkgs> { }).lib.debug;
with (import <nixpkgs> { }).lib.trivial;
let
  input = readFile ./sample.txt;
in
{
  res1 = input;
  res2 = input;
}
