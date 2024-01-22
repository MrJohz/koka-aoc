import std/os/file;
import std/os/path;
import std/text/parse;

value struct position
  x: int
  y: int


fun position/show(pos: position): string
  "Position(x=" ++ pos.x.show ++ ", y=" ++ pos.y.show ++ ")"

value struct file
   lines: list<list<char>>

fun index(f: file, i: position): maybe<char>
  match f.lines.index(i.y)
    Just(row) -> row.list/index(i.x)
    Nothing -> Nothing


fun parts(f: file): list<(position, char)>
  var y := 0
  with row <- f.lines.flatmap
  var x := 0
  y := y + 1
  with char <- row.filter-map
  x := x + 1
  if char.is-digit() || char == '.' then Nothing
  else Just((Position(x - 1, y - 1), char))


fun inputs(): <exn, fsys> file
  read-text-file("." / "inputs" / "day3.txt").lines()
  .filter(fn(line) line != "")
  .map(fn(line) line.list)
  .File


fun part1(lines: file): <div> int
  val chars = lines.parts
  chars.map fn((pos, c))
    pos.show.trace
    c.show.trace
  0
  

fun part2(lines: file): <div> int
  0

pub fun main()
  val part1 = inputs().part1()
  println("Part 1: " ++ part1.show)
  val part2 = inputs().part2()
  println("Part 2: " ++ part2.show)
