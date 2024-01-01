import std/os/file;
import std/os/path;

fun fuel-requirement-part1(mass: int): <div> int {
  mass / 3 - 2
}

fun fuel-requirement-part2(mass: int): <div> int {
  val fuel = mass / 3 - 2;
  if (fuel <= 0) then {
    0
  } else {
    fuel + fuel-requirement-part2(fuel)
  }
}

fun inputs(): <exn, fsys> list<int> {
  read-text-file("." / "inputs" / "day1.txt").lines().flatmap-maybe() fn (line) {
    parse-int(line)
  }
}

pub fun main() {
  val part1 = inputs().map(fuel-requirement-part1).sum()
  val part2 = inputs().map(fuel-requirement-part2).sum()
  println("Part 1: " ++ part1.show)
  println("Part 2: " ++ part2.show)
}
