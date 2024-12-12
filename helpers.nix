with (import <nixpkgs>{}).lib.strings;
with (import <nixpkgs>{}).lib.lists;
with (import <nixpkgs>{}).lib;
with builtins;
rec {
  # grids
  elemAtVec = g: v: elemAt (elemAt g v.y) v.x;
  dimensions = g: {xlen = length (elemAt g 0); ylen = length g;};
  withinGridBounds = d: v: (v.x >= 0 && v.y >= 0 && v.x < d.xlen && v.y < d.ylen);
  neighVH = [{x = 0; y = -1;} {x = 1; y = 0;} {x = 0; y = 1;} {x = -1; y = 0;}];
  neighVHD = neighVH ++ [{x = -1; y = -1;} {x = 1; y = -1;} {x = 1; y = 1;} {x = -1; y = 1;}];

  # vector operations
  vecSet = l: foldl (acc: v: acc // {${vecStr v} = 1;}) {} l;
  vecStr = v: "${toString v.x},${toString v.y}";
  sameDirection = a: b: (dotVec a b) > 0;
  magSquared = a: dotVec a a;
  collinear = a: b: (a.x * b.y - a.y * b.x) == 0;
  scaleVec = i: v: {x = v.x * i; y = v.y * i;};
  dotVec = a: b: (a.x * b.x + a.y * b.y);
  addVec = a: b: {x = (a.x + b.x); y = (a.y + b.y);};
  subVec = a: b: {x = (a.x - b.x); y = (a.y - b.y);};

  # string processing
  explode = s: init (tail (splitString "" s));
  lines = s: init (splitString "\n" s);
  spaces = s: splitString " " s;
  stringGrid = s: (map (x: filter (y: y != "") (explode x)) (lines s));
  spacedInts = s: map toInt (splitString " " s);

  # lists
  sum = l: foldl (acc: e: acc+e) 0 l;
  pairs = l: init (imap0 (i: v: take 2 (drop i l)) l);
  combos = eList: size:
    if size == 0
    then []
    else if size == 1
    then map singleton eList
    else mapCartesianProduct ({x,y}: [x] ++ y) {x=eList; y=combos eList (size - 1);};

  memo = cache: f: args:
    let
      key = toString args;
    in
    if hasAttr key cache
    then getAttr key cache
    else
      let
        val = f args;
        c = cache // {${key} = val;};
      in
        memo c f args;

  # numbers
  abs = x: if (x < 0) then -x else x;
}
