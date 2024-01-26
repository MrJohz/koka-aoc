import std/os/file;
import std/os/path;
import std/text/parse;
import std/core/list;

value struct position
  x: int
  y: int


fun position/show(pos: position): string
  "Position(x=" ++ pos.x.show ++ ", y=" ++ pos.y.show ++ ")"

fun position/left(pos: position): position
  pos(x = pos.x - 1)

fun position/up(pos: position): position
  pos(y = pos.y - 1)

fun position/right(pos: position): position
  pos(x = pos.x + 1)

fun position/down(pos: position): position
  pos(y = pos.y + 1)

value struct file
   lines: vector<vector<char>>

fun at(f: file, i: position): maybe<char>
  match f.lines.at(i.y)
    Just(row) -> row.at(i.x)
    Nothing -> Nothing

fun at-string(f: file, (start, end): (position, position)): string
  var chars := Nil
  for(start.y, end.y) fn(y)
    for(start.x, end.x) fn(x)
      match f.at(Position(x, y))
        Just(char) -> chars := Cons(char, chars)
        Nothing -> ()
  
  chars.reverse.string

fun file/foreach-indexed(fl: file, func: (position, char) -> e ()) : e ()
  fl.lines.foreach-indexed fn (y, row)
    row.foreach-indexed fn(x, c)
      func(Position(x, y), c)


fun any(): parse bool  {
  char-is("", fn (_) True);
  True
}

tail fun parse-ints(): <parse,div> list<int>
  tail fun parse-ints-rec(acc: list<int>): <parse,div> list<int>
    match optional(Nothing, fn() Just(pnat()))
      Just(x) -> parse-ints-rec(Cons(x, acc))
      Nothing -> 
        if any() then parse-ints-rec(acc)
        else acc
  parse-ints-rec([])


fun parts(f: file): list<(position, char)>
  var parts := Nil
  f.foreach-indexed fn(pos, c)
    if c.is-digit() || c == '.' then ()
    else
      parts := Cons((pos, c), parts)
  parts


fun inputs(): <exn, fsys> file
  read-text-file("." / "inputs" / "day3.txt").lines()
  .filter(fn(line) line != "")
  .map(fn(line) line.vector)
  .vector
  .File


fun surrounding-numbers(lines: file, pos: position): div list<int>
  var numbers := Nil

  val is-digit = fn (p: position): bool
    match lines.at(p)
      Just(char) -> char.is-digit()
      Nothing -> False

  var topleft := pos.up.left

  while { is-digit(topleft) }
    topleft := topleft.left

  var topright := pos.up.right
  while { is-digit(topright) }
    topright := topright.right

  val ints = lines.at-string((topleft, topright)).slice.parse(parse-ints).maybe.default([])
  ints.show.trace
  []


fun part1(lines: file): <div> int
  val chars = lines.parts
  chars.map fn((pos, c))
    pos.show.trace
    c.show.trace
    lines.surrounding-numbers(pos).show.trace
  0
  

fun part2(lines: file): <div> int
  0

pub fun main()
  val part1 = inputs().part1()
  println("Part 1: " ++ part1.show)
  val part2 = inputs().part2()
  println("Part 2: " ++ part2.show)
