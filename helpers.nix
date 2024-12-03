with (import <nixpkgs>{}).lib.strings;
with (import <nixpkgs>{}).lib.lists;
with builtins;
{
  abs = x: if (x < 0) then -x else x;
  pairs = l: init (imap0 (i: v: take 2 (drop i l)) l);
  lines = s: init (splitString "\n" s);
  spacedInts = s: map toInt (splitString " " s);
}
