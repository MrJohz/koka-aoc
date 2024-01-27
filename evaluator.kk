// TYPES

type binop
  Add
  Subtract
  Multiply
  Divide

type expression
  Number(int: int)
  BinOp(op: binop, left: expression, right: expression)
  FunctionCall(name: string, arguments: list<expression>)

// FUNCTION CALL EFFECT

rec effect func-call
  ctl call(name: string, evaluate: (expr: expression) -> <func-call,pure> int, args: list<expression>) : int

// EVALUATOR

fun evaluate(expression: expression): <func-call,pure> int
  match expression
    Number(int) -> int
    BinOp(Add, left, right) -> evaluate(left) + evaluate(right)
    BinOp(Subtract, left, right) -> evaluate(left) - evaluate(right)
    BinOp(Multiply, left, right) -> evaluate(left) * evaluate(right)
    BinOp(Divide, left, right) -> evaluate(left) / evaluate(right)
    FunctionCall(name, args) -> 
      call(name, evaluate, args)

// EXAMPLE PARSE TREES

fun expr-addition(): expression
  BinOp(Add, Number(1), BinOp(Add, Number(2), Number(3)))

fun expr-function-sum(): expression
  FunctionCall("SUM", [Number(0), Number(1), Number(2)])

fun expr-function-product(): expression
  FunctionCall("PRODUCT", [Number(5), Number(6), Number(2)])

fun expr-unknown-function-call(): expression
  FunctionCall("UNKNOWN_FUNCTION_NAME", [Number(0)])

fun expr-nested-unknown-call(): expression
  FunctionCall("PRODUCT", [
    FunctionCall("UNKNOWN_FUNCTION_NAME", [
      FunctionCall("SUM", [])
    ])
  ])

fun expr-thunked-if(no: int): expression
  FunctionCall("IF", [
    Number(no), // if no !== 0
    FunctionCall("ERROR_DOES_NOT_EXIST", []),
    Number(1),
  ])


// effect handler/main

value type function-error
  NotFound(name: string)
  InvalidArguments(name: string)

fun function-error/show(err: function-error): string
  match err
    NotFound(name) -> "NotFound(" ++ name ++ ")"
    InvalidArguments(name) -> "InvalidArguments(" ++ name ++ ")"

fun functions-handler(eval: () -> <func-call|e> int): e either<function-error, int>
  with ctl call(name, evaluator, args)
    trace("  evaluating call: " ++ name)
    match name.to-lower
      "sum" ->
        args.map-while fn(arg)
          val result = with functions-handler { evaluator(arg) }
          match 
        .sum
        .resume
      // "product" -> resume(args.foldl(1) fn(prev, arg) prev * evaluator(arg))
      // "if" -> match args
      //   [testee, left, right] -> resume(if evaluator(testee) == 0 then evaluator(left) else evaluator(right))
      //   _ -> Left(InvalidArguments(name.to-upper))
      
      _ -> Left(NotFound(name.to-upper))

  Right(eval())

fun main()
  println("Addition of values:")
  match (functions-handler(fn() evaluate(expr-addition())))
    Left(error) -> error.show.println()
    Right(result) -> result.show.println()

  println("Eval'ing function call (sum):")
  match (functions-handler(fn() evaluate(expr-function-sum())))
    Left(error) -> error.show.println()
    Right(result) -> result.show.println()

  println("Eval'ing function call (product):")
  match (functions-handler(fn() evaluate(expr-function-product())))
    Left(error) -> error.show.println()
    Right(result) -> result.show.println()

  println("Eval'ing function call (unknown):")
  match (functions-handler(fn() evaluate(expr-unknown-function-call())))
    Left(error) -> error.show.println()
    Right(result) -> result.show.println()

  println("Eval'ing function call (unknown nested):")
  match (functions-handler(fn() evaluate(expr-nested-unknown-call())))
    Left(error) -> error.show.println()
    Right(result) -> result.show.println()

  println("Eval'ing function call (if/argument thunks false):")
  match (functions-handler(fn() evaluate(expr-thunked-if(0))))
    Left(error) -> error.show.println()
    Right(result) -> result.show.println()

  println("Eval'ing function call (if/argument thunks true):")
  match (functions-handler(fn() evaluate(expr-thunked-if(1))))
    Left(error) -> error.show.println()
    Right(result) -> result.show.println()
