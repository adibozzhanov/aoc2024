with (import <nixpkgs>{}).lib.strings;
with (import <nixpkgs>{}).lib.lists;
with builtins;
rec {
  sum = l: foldl (acc: e: acc+e) 0 l;
  abs = x: if (x < 0) then -x else x;
  pairs = l: init (imap0 (i: v: take 2 (drop i l)) l);
  lines = s: init (splitString "\n" s);
  stringGrid = s: (map (x: filter (y: y != "") (splitString "" x)) (lines s));
  spacedInts = s: map toInt (splitString " " s);
}
