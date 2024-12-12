with (import <nixpkgs>{}).lib.strings;
with (import <nixpkgs>{}).lib.lists;
with (import <nixpkgs>{}).lib;
with builtins;
rec {
  # step through the cache
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

  # create a cache for a function that takes 1 numeric argument
  # f: n -> any
  initNumericCache = f: {
    head = {arg = 0; res = (f 0);};
    depth = 0;
    tail1 = cacheStep 0 (n: {arg = n; res = f n;}) 1;
    tail2 = cacheStep 0 (n: {arg = n; res = f n;}) 2;
    tail3 = cacheStep 0 (n: {arg = n; res = f n;}) 3;
    tail4 = cacheStep 0 (n: {arg = n; res = f n;}) 4;
    tail5 = cacheStep 0 (n: {arg = n; res = f n;}) 5;
    tail6 = cacheStep 0 (n: {arg = n; res = f n;}) 6;
    tail7 = cacheStep 0 (n: {arg = n; res = f n;}) 7;
    tail8 = cacheStep 0 (n: {arg = n; res = f n;}) 8;
    tail9 = cacheStep 0 (n: {arg = n; res = f n;}) 9;
  };


  recursiveCacheStep = f: n:
    let newHead = f n;
    in { head = newHead; tail = recursiveCacheStep f (n + 1);};

  # create cache for
  # f: n -> (n -> n)
  initRecursiveCache = f:
    let
      g = f 0;
      gCache = initNumericCache g;
      cg = getFromCache gCache;
    in
    {
      head = {arg = 0; res = cg;};
      tail = recursiveCacheStep (n: {
        arg = n;
        res = let
          gg = f n;
          ggCache = initNumericCache gg;
        in
          getFromCache ggCache;
      }) 1;
    };

  getFromRecursiveCache = {head, tail}: n: if (head.arg ==  n) then head.res else getFromRecursiveCache tail n;

  getFromCache = {head,depth, ...}@rest: n: if (head.arg == n) then head.res else
    let key = "tail${substring depth 1 (toString n)}";
    in getFromCache (getAttr key rest) n;

  wrapInCache = f: rec {
    c = initRecursiveCache f;
    wrapped = getFromRecursiveCache c;
  };
}
