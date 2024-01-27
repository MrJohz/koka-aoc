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

alias evalthunk = int

effect func-call
  ctl call(name: string, args: list<evalthunk>) : int

// EVALUATOR

fun evaluate(expression: expression): <div,exn,func-call> int
  match expression
    Number(int) -> int
    BinOp(Add, left, right) -> evaluate(left) + evaluate(right)
    BinOp(Subtract, left, right) -> evaluate(left) - evaluate(right)
    BinOp(Multiply, left, right) -> evaluate(left) * evaluate(right)
    BinOp(Divide, left, right) -> evaluate(left) / evaluate(right)
    FunctionCall(name, args) -> 
      val thunks = args.map fn(arg) evaluate(arg)
      call(name, thunks)

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


// effect handler/main

type function-error
  NotFound(name: string)

fun function-error/show(err: function-error): string
  match err
    NotFound(name) -> "NotFound(" ++ name ++ ")"

fun functions-handler(eval: () -> <func-call|e> int): e either<function-error, int>
  with ctl call(name, args)
    trace("  evaluating call: " ++ name)
    match name.to-lower
      "sum" -> resume(args.sum)
      "product" -> resume(args.foldl(1) fn(prev, i) prev * i)
      
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
