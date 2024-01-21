import std/os/file;
import std/os/path;
import std/text/parse;

fun inputs(): <exn, fsys> list<string>
  read-text-file("." / "inputs" / "day2.txt").lines().filter() fn(line)
    line != ""

fun part1(lines: list<string>): <div> int
  0

fun part2(lines: list<string>): <div> int
  0

pub fun main()
  val part1 = inputs().part1()
  println("Part 1: " ++ part1.show)
  val part2 = inputs().part2()
  println("Part 2: " ++ part2.show)
