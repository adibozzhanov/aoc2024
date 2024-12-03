with (import <nixpkgs>{}).lib.strings;
with (import <nixpkgs>{}).lib.lists;
with builtins;
let
  input = readFile ./input.txt;
  parse2 = s: map (x:
    if x == "do()"
    then true
    else if x == "don't()"
    then false
    else x
  ) (flatten (filter isList (split "(don't[(][)]|do[(][)]|mul[(][[:digit:]][[:digit:]]?{2},[[:digit:]][[:digit:]]?{2}[)])" s)));
  parse = s: map (x: map toInt x) (filter isList (split "mul[(]([[:digit:]][[:digit:]]?{2}),([[:digit:]][[:digit:]]?{2})[)]" s));
  solve1 = s: foldl (acc: x: acc + x) 0 (map (x: (head x) * (last x)) (parse s));
  solve2 = s: solve1 (foldl (acc: e: acc+e) "" (last (foldl (acc: e:
    if isString e
    then if (head acc)
         then [(head acc) ((last acc) ++ [e])]
         else [(head acc) (last acc)]
    else [e (last acc)]
  ) [true []] (parse2 s))));
in
{
  res1 = solve1 input;
  res2 = solve2 input;
}
