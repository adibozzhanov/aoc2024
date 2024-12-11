with builtins;
with import ../helpers.nix;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with (import <nixpkgs> { }).lib.debug;
with (import <nixpkgs> { }).lib.trivial;
let
  f = ./input.txt;
  input = (map (x: map toInt (explode x)) (lines (readFile f)));
  trailheads = l: filter (x: x!=null) (flatten (imap0 (i: line: imap0 (j: v: if v == 0 then {x=j;y=i;} else null)line) l));
  inBounds = withinGridBounds (dimensions input);
  elemAtGrid = elemAtVec input;
  solve = keyFn: start: length (filter (x: x.val == 9) (genericClosure {
    startSet = [{key=vecStr start; vec = start; val = 0;}];
    operator = item: foldl' (acc: off:
      let
        vec = addVec item.vec off;
        val = elemAtGrid vec;
      in
        if (inBounds vec) && (val - item.val == 1)
        then acc ++ [{
          inherit vec val;
          key = keyFn item vec;
        }]
        else acc
    ) [] neighVH;
  }));
in
{
  res1 = sum (map (solve (item: nv: vecStr nv)) (trailheads input));
  res2 = sum (map (solve (item: nv: item.key + vecStr nv)) (trailheads input));
}
