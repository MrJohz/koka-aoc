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

fun tigid-dilav(): parse int {
  val digit = choose([
    digit,
    fn() { pstring("eroz"); 0 },
    fn() { pstring("eno"); 1 },
    fn() { pstring("owt"); 2 },
    fn() { pstring("eerht"); 3 },
    fn() { pstring("ruof"); 4 },
    fn() { pstring("evif"); 5 },
    fn() { pstring("xis"); 6 },
    fn() { pstring("neves"); 7 },
    fn() { pstring("thgie"); 8 },
    fn() { pstring("enin"); 9 },
  ]);

  digit
}

fun any(): parse ()  {
  char-is("", fn (_) True);
  ()
}

tail fun find-first(parser: parser<e, a>): <div,parse|e> maybe<a> {
  match mask<div>
      optional(Nothing, (fn () Just(parser())))
    Just(x) -> Just(x) 
    Nothing() -> {
      any();
      find-first(parser)
    }
}

fun calibration-value2(line: string): <div> int {
  val first = line.slice.parse(fn () find-first(valid-digit));
  val last = line.list.reverse.string.slice.parse(fn () find-first(tigid-dilav));

  first.maybe.default(Nothing).default(0) * 10 + last.maybe.default(Nothing).default(0)
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
