with (import <nixpkgs>{}).lib.lists;
with import ../helpers.nix;
with builtins;
let
  input = (map spacedInts (lines (readFile ./input.txt)));
  difs = l: map (x: map (l: (head l) - (last l)) (pairs x)) l;
  isSafe = l: (all (x: (x > 0)) l || (all (x: (x < 0)) l)) && (all (x: (x <= 3 && x >= 1)) (map abs l));
  levelReductions = l: (imap0 (i: v: (take i l) ++ (drop (i+1) l)) l);
in
{
  res1 = count (x: x) (map isSafe (difs input));
  res2 = count (x: x) (map (x: (any (x: x) ((map isSafe (difs ((levelReductions x))))))) input);
}
