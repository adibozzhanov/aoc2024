with builtins;
with import ../helpers.nix;
with (import <nixpkgs> { }).lib.lists;
with (import <nixpkgs> { }).lib.strings;
with (import <nixpkgs> { }).lib.debug;
with (import <nixpkgs> { }).lib.trivial;
with (import <nixpkgs> { }).lib;

# nix doesn't support writing to individual array elements.
# so every time we have to write to an array index... we HAVE TO copy the entire array
# This turns any linear task on an array into quadratic.
# And we also don't have while loops... so doing a neat recursive approach explodes the stack
# though we DO have a genericClosure... with this we can tackle both of our issues.
# yes... by having 9 function params but who cares...

let
  f = ./input.txt;
  input = map toInt (explode (head (lines (readFile f))));
  lastId = l: (foldl' (acc: val: {ind = acc.ind + 1; val = if (mod acc.ind 2) == 0 then acc.val + 1 else acc.val;}) {ind = 0; val=-1;} l).val;

  ss = genericClosure {
    startSet = [(rec {
      key = 0;
      left = 0;
      id = 0;
      right = lastId input;
      res = 0;
      listIndex = 0;
      endIndex = (length input) - 1;
      endValue = elemAt input endIndex;
      isBlock = true;
    })];
    operator = item: [(
      if item.isBlock
      then sb item
      else se item
    )];
  };

  sb = {key,id,left,right,res,listIndex,endIndex,endValue,isBlock}:
    let
      value = (elemAt input listIndex);
    in
      {
        inherit right left endIndex endValue;
        id = id + value;
        key = if left <= right then key + 1 else 0;
        listIndex = listIndex + 1;
        res = foldl' (acc: i: acc + (i*left)) res (range id (if left < right then (id + value - 1) else (id + endValue - 1)));
        isBlock = false;
      };

  se = {key,id,left,right,res,listIndex,endIndex,endValue,isBlock}:
    let
      value = (elemAt input listIndex);
      collect = foldl' (
          acc: v:
          let
            x = with acc; getRightId ev ei ri;
          in
            {
              ei = x.ei;
              ev = x.ev;
              ri = x.ri;
              re = acc.re + x.ri * v;
            }
        ) {ei = endIndex; ev = endValue; ri = right; re = res;} (range id (id + value - 1));
    in
      {
        key = if left < right then key + 1 else 0;
        id = id + value;
        listIndex = listIndex + 1;
        res = collect.re;
        left = left + 1;
        right = collect.ri;
        endIndex = collect.ei;
        endValue = collect.ev;
        isBlock = true;
      };

  getRightId = endVal: endInd: rightId:
    if endVal == 0
    then rec {
      ei = endInd - 2;
      ev = (elemAt input ei) - 1;
      ri = rightId - 1;
    }
    else {
      ev = endVal - 1;
      ei = endInd;
      ri = rightId;
    };
in
{
  res1 = last (map (x: x.res) ss);
}
