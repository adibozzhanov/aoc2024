with builtins;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with import ../helpers.nix;
let
  input =
    let
      l = lines (readFile ./input.txt);
      emptyIndex = findFirstIndex (x: x == "") null l;
    in
      {
        rules = map (c: (map toInt (splitString "|" c))) (take (emptyIndex) l);
        pages = map (c: (map toInt (splitString "," c))) (drop (emptyIndex + 1) l);
      };

  preprocessRules = rs:
    foldl (acc: rule:
      let
        key = toString (head rule);
        value = last rule;
      in
        acc // {${key} =
                if hasAttr key acc
                then [value] ++ (getAttr key acc)
                else [value] ;}
    ) {} rs;

  ruleViolation = l: seen: rules:
    let
      elem = head l;
      elemKey = toString elem;
      rest = tail l;
    in
      if length l == 0
      then false
      else
        if (hasAttr elemKey rules)
        then
          let
            lesser = getAttr elemKey rules;
          in
            ((length (intersectLists lesser seen)) != 0) || (ruleViolation rest (seen ++ [elem]) rules)
        else ruleViolation rest (seen ++ [elem]) rules;

  sortByRules = rules: l:  sort (
    a: b:
    let
      key = toString a;
    in
      if hasAttr key rules
      then elem b (getAttr key rules)
      else false
  ) l;
in
rec {
  res1 = sum (map (l: elemAt l ((length l) / 2)) (filter (p: !(ruleViolation p [] (preprocessRules input.rules))) input.pages));
  res2=
    let
      prules = (preprocessRules input.rules);
    in sum (map (l: elemAt l ((length l) / 2)) (map (sortByRules prules) (filter (p: (ruleViolation p [] prules)) input.pages)));
}
