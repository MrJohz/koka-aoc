import std/os/file;
import std/os/path;
import std/text/parse;

fun calibration-value1(line: string): int {
  val chars = line.list().filter() fn(c) {
    c.is-digit()
  }

  val first = chars.head().map(fn(c) { c.int - '0'.int}).default(0)
  val last = chars.last().map(fn(c) { c.int - '0'.int}).default(0)

  first * 10 + last
}

fun valid-digit(): parse int {
  val digit = choose([
    digit,
    fn() { pstring("zero"); 0 },
    fn() { pstring("one"); 1 },
    fn() { pstring("two"); 2 },
    fn() { pstring("three"); 3 },
    fn() { pstring("four"); 4 },
    fn() { pstring("five"); 5 },
    fn() { pstring("six"); 6 },
    fn() { pstring("seven"); 7 },
    fn() { pstring("eight"); 8 },
    fn() { pstring("nine"); 9 },
  ]);

  digit
}

fun any(): parse ()  {
  char-is("", fn (_) True);
  ()
}

fun find-first(parser: parser<e, a>): <parse|e> maybe<a> {
  match optional(Nothing, (fn () Just(parser()))) {
    Just(x) -> Just(x) 
    Nothing() -> {
      any();
      find-first(parser)
    }
  }
}

fun calibration-value2(line: string): <div> int {
  // TODO: also find last instance of valid-digit
  val value = line.slice.parse(fn () find-first(valid-digit));
  value.maybe.default(Nothing).default(0)
}


fun inputs(): <exn, fsys> list<string> {
  read-text-file("." / "inputs" / "day1.txt").lines().filter() fn(line) {
    line != ""
  }
}

pub fun main() {
  val part1 = inputs().map(calibration-value1).sum()
  println("Part 1: " ++ part1.show)
  val part2 = inputs().map(calibration-value2).sum()
  println("Part 2: " ++ part2.show)
}
