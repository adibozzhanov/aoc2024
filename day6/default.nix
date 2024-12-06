with builtins;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with (import <nixpkgs> { }).lib.trivial;
with import ../helpers.nix;

let
  f = ./input.txt;
  dirs = [{x=0;y=-1;} {x=1;y=0;} {x=0;y=1;} {x=-1;y=0;}];
  getDirVec = d: elemAt dirs d;
  rotate = d: mod (d + 1) 4;
  bounds = let
    grid = map explode (lines (readFile f));
  in {xlen = length (elemAt grid 0); ylen = length grid;};
  input = flatten (imap0 (i: line: let exp = explode line; in (imap0 (j: c: {c=c; x = j; y = i;}) exp)) (lines (readFile f)));
  src = let t = (findSingle (x: x.c == "^") "NOPE" "NOPE" input); in {x = t.x; y = t.y;};
  obs = map (x: {x = x.x; y=x.y;}) (filter (x: x.c == "#") input);
  pointsInBetween = a: b: dir:
    let
      d = subVec b a;
      dirVec = getDirVec dir;
      dist = abs (if d.x == 0 then d.y else d.x) - 1;
    in
      foldl (acc: i:
        let
          v = addVec (scaleVec i dirVec) a;
          key = vecStr v;
        in
          (acc // {${key} = 1;})
      ) {} (range 1 dist);


  boundVecs = pos:
    [
      {x= pos.x; y= -1;}
      {x = bounds.xlen; y = pos.y;}
      {x = pos.x; y = bounds.ylen;}
      {x = -1; y = pos.y;}
    ];

  finalPoint = pos: dir: elemAt (boundVecs pos) dir;
  findObstacle1 = o: pos: dir:
    let
      target = take 1 (sort
        (a: b:
          let
            d1 = magSquared (subVec a pos);
            d2 = magSquared (subVec b pos);
          in
            d2 - d1 > 0
        )
        (filter (o:
          let
            difVec = subVec o pos;
            dirVec = getDirVec dir;
          in
            (sameDirection difVec dirVec) && (collinear difVec dirVec)
        ) o));
    in
      if length target > 0
      then head target
      else null;

  findObstacle = findObstacle1 obs;

  solve1 = pos: dir: acc:
    let
      obst = findObstacle pos dir;
      dirVec = getDirVec dir;
    in
      if (obst != null)
      then solve1 (subVec obst dirVec) (rotate dir) (acc // (pointsInBetween pos obst dir))
      else acc // (pointsInBetween pos (finalPoint pos dir) dir);

  hasCycle = o: posSet: pos: dir:
    let
      obst = findObstacle1 o pos dir;
      dirVec = getDirVec dir;
      makeKey = p: d: "${vecStr p}-${toString d}";
    in
      if obst == null
      then false
      else if hasAttr (makeKey pos dir) posSet
      then true
      else
        let
          newPos = (subVec obst dirVec);
          newDir = rotate dir;
        in hasCycle o (posSet // {${makeKey pos dir} = 1;}) newPos newDir;
  solve2 =
    let
      sol1 = map (x: let v = (map toInt (splitString "," x)); in {x=head v; y = last v;}) (attrNames (removeAttrs (solve1 src 0 {"${vecStr src}" = 1;}) [(vecStr src)]));
    in
      length (filter (p: hasCycle (obs ++ [p]) {} src 0) sol1);
in
{
  res1 = length (attrNames (solve1 src 0 {"${vecStr src}" = 1;}));
  res2 = solve2;
}
