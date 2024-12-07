with builtins;
with import ../helpers.nix;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with (import <nixpkgs> { }).lib.debug;
with (import <nixpkgs> { }).lib.trivial;
let
  f = ./input.txt;
  input = map (line: let l = (spaces line); in {
    expected = toInt (foldl' (acc: x: acc+ x) "" (init (explode (head l))));
    ops = map toInt (tail l);
  }) (lines (readFile f));

  opsMap = { "*" = mul; "+" = add; "||" = intCat; };
  intCat = (x: y: toInt((toString x) + (toString y)));
  getOp = ops: ind: getAttr (elemAt ops ind) opsMap;
  eval = nums: ops: (foldl' (acc: x: {cur = (getOp ops acc.ind) acc.cur x; ind = acc.ind+1;}) ({cur = head nums; ind = 0;}) (tail nums)).cur;
  solve = opSet: tgt: nums: any (c: (eval nums c) == tgt) (combos opSet ((length nums) - 1));
in
{
  res1 = sum (map (x: x.expected)(filter (x: solve ["*" "+"] x.expected x.ops) input));
  res2 = sum (map (x: x.expected)(filter (x: solve ["*" "||" "+"] x.expected x.ops) input));
}
