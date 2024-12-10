with (import <nixpkgs>{}).lib.strings;
with (import <nixpkgs>{}).lib.lists;
with (import <nixpkgs>{}).lib;
with builtins;
rec {
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

  # numbers
  abs = x: if (x < 0) then -x else x;
}
