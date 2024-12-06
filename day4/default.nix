with (import <nixpkgs> { }).lib.strings;
with (import <nixpkgs> { }).lib.lists;
with import ../helpers.nix;
with builtins;
let
  input = stringGrid (readFile ./input.txt);

  dirs = [
    {x = 1; y = 0;}
    {x = 1; y = 1;}
    {x = 0; y = 1;}
    {x = -1; y = 1;}
    {x = -1; y = 0;}
    {x = -1; y = -1;}
    {x = 0; y = -1;}
    {x = 1; y = -1;}
  ];

  makeGrid = g: {
    xlen = length (elemAt g 0);
    ylen = length g;
    body = g;
  };

  hasWord = word: grid: pos: dir:
    let
      listWord = filter (x: x != "") (splitString "" word);
      gridWord = foldl (
        acc: c:
        let
          x = acc.p.x + dir.x;
          y = acc.p.y + dir.y;
          inBounds = (x >= 0) && (y >= 0) && (x < grid.xlen) && (y < grid.ylen);
        in
          if inBounds
          then {p = {inherit x y;}; w=acc.w + (elemAt (elemAt grid.body y) x);}
          else acc
      ) {p = {x=(pos.x - dir.x); y=(pos.y - dir.y);}; w = "";} listWord;
    in gridWord.w == word;

  countXmas =
    grid:
    let
      inputGrid = makeGrid grid;
    in
      sum (imap0 (i: row: sum (imap0 (j: _:
        let
          pos = {x=j; y=i;};
        in
          count (dir: hasWord "XMAS" inputGrid pos dir) dirs) row)) inputGrid.body);

  countMas =
    grid:
    let
      inputGrid = makeGrid grid;
    in
      sum (imap0 (i: row: sum (imap0 (j: c:
        let
          pos = {x = j; y = i;};
          masDirs = [
              {x= 1; y = 1;}
              {x= -1; y = 1;}
              {x= -1; y = -1;}
              {x= 1; y = -1;}
          ];
          hasMas = pos: dir: (hasWord "MAS" inputGrid pos dir);
        in
        if (c == "A") &&
           (
             (hasMas {x = pos.x - 1; y = pos.y - 1;} {x=1; y=1;}) ||
             (hasMas {x = pos.x + 1; y = pos.y + 1;} {x=-1; y=-1;})
           ) &&
           (
             (hasMas {x = pos.x + 1; y = pos.y - 1;} {x=-1; y=1;}) ||
             (hasMas {x = pos.x - 1; y = pos.y + 1;} {x=1; y=-1;})
           )
        then 1
        else 0
      ) row)) inputGrid.body);
in
{
  res1 = countXmas input;
  res2 = countMas input;
}
