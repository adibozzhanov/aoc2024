with builtins;
with import ../helpers.nix;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with (import <nixpkgs> { }).lib.debug;
with (import <nixpkgs> { }).lib.trivial;
let
  f = readFile ./input.txt;
  input = map explode (lines f);
  processed = flatten (imap0 (i: line: filter (x: !(isNull x)) (imap0 (j: char:
    if (char != ".")
    then {x = j; y = i; c = char;}
    else null
  ) line)) input);
  positionMap = foldl (acc: val:
    let
      key = val.c;
      new = {${val.c} = [{x=val.x; y=val.y;}];};
    in
    if hasAttr val.c acc
    then acc // ({${key} = acc.${key} ++ new.${key};})
    else acc // new
  ) {} processed;

  dimensions = {xlen = length (elemAt input 0); ylen = length input;};
  inBounds = v: (v.x >= 0) && (v.y >= 0) && (v.x < dimensions.xlen) && (v.y < dimensions.ylen);
  pairCombos = l: (filter (x: (head x) != (last x)) (combos l 2));
  vecPairsToRays = vecPairs: map (x: {dir = subVec (last x) (head x); start = last x;}) vecPairs;
  positionsFromRay = r:
    if inBounds r.start
    then [r.start] ++ (positionsFromRay {dir = r.dir; start = addVec r.dir r.start;})
    else [];
  antinodes = posList: vecSet (filter inBounds (map (r: addVec r.dir r.start) (vecPairsToRays (pairCombos posList))));
  antinodes2 = posList: vecSet (flatten (map positionsFromRay (vecPairsToRays (pairCombos posList))));
in
{
  res1 = length (attrNames (foldl (acc: x: acc // antinodes x) {} (attrValues positionMap)));
  res2 = length (attrNames (foldl (acc: x: acc // antinodes2 x) {} (attrValues positionMap)));
}
