with (import <nixpkgs>{}).lib.strings;
with (import <nixpkgs>{}).lib.lists;
with builtins;
rec {
  # vector operations
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
  stringGrid = s: (map (x: filter (y: y != "") (explode x)) (lines s));
  spacedInts = s: map toInt (splitString " " s);

  # lists
  sum = l: foldl (acc: e: acc+e) 0 l;
  pairs = l: init (imap0 (i: v: take 2 (drop i l)) l);

  # numbers
  abs = x: if (x < 0) then -x else x;
}
