import std/os/file;
import std/os/path;
import std/text/parse;

value struct draw
  red: int
  green: int
  blue: int

fun show(draw: draw): string {
  "Draw(red = " ++ draw.red.show ++ ", green = " ++ draw.green.show ++ ", blue = " ++ draw.blue.show ++ ")"
}

fun sep(sep: string, next: (a) -> <parse|e> a, current: a): <parse|e> a
  val parsed = optional(False, (fn() { pstring(sep); True }))
  if parsed then
    next(current)
  else
    current


type drawoption
  Red
  Green
  Blue

fun draw(initial: draw): <div, parse> draw
  val this-draw = pnat()
  whitespace()
  val color = choose([
    fn() { pstring("red"); Red },
    fn() { pstring("green"); Green },
    fn() { pstring("blue"); Blue }
  ])

  match color
    Red -> sep(", ", draw, initial(red = this-draw))
    Green -> sep(", ", draw, initial(green = this-draw))
    Blue -> sep(", ", draw, initial(blue = this-draw))

fun draws(initial: list<draw>): <div, parse> list<draw>
  val draw = draw(Draw(red = 0, green = 0, blue = 0))
  sep("; ", draws, Cons(draw, initial))

fun line-parser(): <div, parse> list<draw>
  pstring("Game")
  whitespace()
  pnat()
  pstring(":")
  whitespace()
  draws([])

fun inputs(): <exn, fsys> list<string>
  read-text-file("." / "inputs" / "day2.txt").lines().filter() fn(line)
    line != ""

fun parse-lines(lines: list<string>): <div> list<list<draw>>
  lines.flatmap-maybe() fn(line)
    match line.slice.parse-eof(line-parser).either
      Left(err) ->
        err.trace-show()
        Nothing
      Right(draws) ->
        Just(draws)

fun part2(lines: list<string>): <div> int
  lines.parse-lines().map() fn(line)
    line.foldl(Draw(red=0, green=0, blue=0)) fn(acc, draw)
      acc(red = acc.red.max(draw.red), green = acc.green.max(draw.green), blue = acc.blue.max(draw.blue))
  .map() fn(line)
    line.red * line.green * line.blue
  .foldl(0, (+))

pub fun main()
  val part1 = inputs().part2()
  println("Part 1: " ++ part1.show)
  val part2 = inputs().part2()
  println("Part 2: " ++ part2.show)
