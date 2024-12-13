with (import <nixpkgs>{}).lib.strings;
with (import <nixpkgs>{}).lib.lists;
with (import <nixpkgs>{}).lib;
with builtins;
rec {
  maybeWrap = f: n:
    let
      v = f n;
    in
    if isFunction v
    then (memo v)
    else v;

  cacheStep = d: f: n:
    let new = f n; dd = d + 1;
    in ({
      head = new;
      depth = dd;
    } // (foldl'  (acc: v: acc // {
      "tail${toString v}" = cacheStep dd f (toIntBase10 ((toString n) + (toString v)));
    }) {} (range 0 9)));

  cacheInit = f: {
    head = {arg = 0; res = maybeWrap f 0;};
    depth = 0;
  } // (foldl' (acc: v: acc // {
    "tail${toString v}" = cacheStep 0 (n: {arg=n; res = maybeWrap f n;}) v;
  }) {} (range 1 9));

  cacheGet = {head,depth, ...}@rest: n: if (head.arg == n) then head.res else
    let key = "tail${substring depth 1 (toString n)}";
    in cacheGet (getAttr key rest) n;

  # memoize any function with any number of NUMERIC arguments
  # f = n -> n -> ... -> n -> any
  memo = f: rec{
    c = cacheInit f;
    wrapped = cacheGet c;
  }.wrapped;
}
