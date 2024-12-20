with builtins;
with import ../helpers.nix;
with import ../cache.nix;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with (import <nixpkgs> { }).lib.debug;
with (import <nixpkgs> { }).lib.trivial;
let
  f = ./input.txt;

  input = spacedInts (head (lines (readFile f)));

  splitInHalves = n:
    let
      s = toString n;
      mid = (stringLength s) / 2;
      p1 = toIntBase10 (substring 0 mid s);
      p2 = toIntBase10 (substring mid mid s);
    in
      [p1 p2];

  rules = n:
    if n == 0
    then [1]
    else if mod (stringLength (toString n)) 2 == 0
    then splitInHalves n
    else [(n * 2024)];

  fun = memo (d: n:
    if d == 0
    then 1
    else sum (map (fun (d - 1)) (rules n)));

in
{
  res1 =  sum (map (fun 25) input);
  res2 =  sum (map (fun 75) input);
}
