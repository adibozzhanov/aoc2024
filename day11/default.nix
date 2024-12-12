with builtins;
with import ../helpers.nix;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with (import <nixpkgs> { }).lib.debug;
with (import <nixpkgs> { }).lib.trivial;
let
  f = ./input.txt;

  input = spacedInts (head (lines (readFile f)));
  splitInHalves = n:
    let
      s = toString n;
      mid = (stringLength s) / 2;
      p1 = toIntBase10 (substring 0 mid s);
      p2 = toIntBase10 (substring mid mid s);
    in
      [p1 p2];

  rules = n:
    if n == 0
    then [1]
    else if mod (stringLength (toString n)) 2 == 0
    then splitInHalves n
    else [(n * 2024)];

  fun = d: n:
    if d == 0
    then 1
    else sum (map (fun (d - 1)) (rules n));


  cacheStep = d: f: n:
    let new = f n; dd = d + 1;
    in {
      head = new;
      depth = dd;
      tail0 = cacheStep dd f (toIntBase10 ((toString n) + (toString 0)));
      tail1 = cacheStep dd f (toIntBase10 ((toString n) + (toString 1)));
      tail2 = cacheStep dd f (toIntBase10 ((toString n) + (toString 2)));
      tail3 = cacheStep dd f (toIntBase10 ((toString n) + (toString 3)));
      tail4 = cacheStep dd f (toIntBase10 ((toString n) + (toString 4)));
      tail5 = cacheStep dd f (toIntBase10 ((toString n) + (toString 5)));
      tail6 = cacheStep dd f (toIntBase10 ((toString n) + (toString 6)));
      tail7 = cacheStep dd f (toIntBase10 ((toString n) + (toString 7)));
      tail8 = cacheStep dd f (toIntBase10 ((toString n) + (toString 8)));
      tail9 = cacheStep dd f (toIntBase10 ((toString n) + (toString 9)));
    };

  rulesCache = {
    head = {arg = 0; res = [1];};
    depth = 0;
    tail1 = cacheStep 0 (n: {arg = n; res = rules n;}) 1;
    tail2 = cacheStep 0 (n: {arg = n; res = rules n;}) 2;
    tail3 = cacheStep 0 (n: {arg = n; res = rules n;}) 3;
    tail4 = cacheStep 0 (n: {arg = n; res = rules n;}) 4;
    tail5 = cacheStep 0 (n: {arg = n; res = rules n;}) 5;
    tail6 = cacheStep 0 (n: {arg = n; res = rules n;}) 6;
    tail7 = cacheStep 0 (n: {arg = n; res = rules n;}) 7;
    tail8 = cacheStep 0 (n: {arg = n; res = rules n;}) 8;
    tail9 = cacheStep 0 (n: {arg = n; res = rules n;}) 9;
  };



  getCached = {head,depth, ...}@rest: n: if (head.arg == n) then head.res else
    let key = "tail${substring depth 1 (toString n)}";
    in getCached (getAttr key rest) n;

  rulesCached = getCached rulesCache;
in
{
  res2 = sum (map (fun 25) [125 17]);
}
