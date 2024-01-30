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
  ctl call(name: string, evaluator: (expr: expression) -> <div,func-call> int, args: list<expression>) : int

// EVALUATOR

fun evaluate(expression: expression): <div,func-call> int
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

fun expr-if-wrong-arg-no(): expression
  FunctionCall("IF", [])


// effect handler/main

effect ctl err-not-found(name: string): a
effect ctl err-invalid-arguments(name: string): a

fun functions-handler(eval: () -> <func-call,div,err-invalid-arguments,err-not-found|e> int): <div,err-not-found,err-invalid-arguments|e> int
  with ctl call(name, evaluator, args)
    trace("  evaluating call: " ++ name)
    match name.to-lower
      "sum" -> args.map(fn(arg) functions-handler { evaluator(arg) }).sum.resume
      "product" ->
        args.map(fn(arg) functions-handler { evaluator(arg) }).foldl(1, fn(prev, arg) prev * arg).resume
      "if" -> match args
        [testee, left, right] -> 
          val test = functions-handler { evaluator(testee) }
          val parameter = if test == 0 then right else left
          (functions-handler { evaluator(parameter) }).resume
        _ -> err-invalid-arguments(name.to-upper)
      
      _ -> err-not-found(name.to-upper)

  eval()

fun error-handler(eval: () -> <err-not-found,err-invalid-arguments|e> int): e string
  with final ctl err-not-found(name) "function not found: " ++ name
  with final ctl err-invalid-arguments(name) "invalid arguments for function: " ++ name
  eval().show

fun main()
  println("Addition of values:")
  (error-handler { functions-handler { evaluate(expr-addition()) } }).println()

  println("Eval'ing function call (sum):")
  (error-handler { functions-handler { evaluate(expr-function-sum()) } }).println()

  println("Eval'ing function call (product):")
  (error-handler { functions-handler { evaluate(expr-function-product()) } }).println()

  println("Eval'ing function call (unknown):")
  (error-handler { functions-handler { evaluate(expr-unknown-function-call()) } }).println()

  println("Eval'ing function call (unknown nested):")
  (error-handler { functions-handler { evaluate(expr-nested-unknown-call()) } }).println()

  println("Eval'ing function call (if/argument thunks false):")
  (error-handler { functions-handler { evaluate(expr-thunked-if(0)) } }).println()

  println("Eval'ing function call (if/argument thunks true):")
  (error-handler { functions-handler { evaluate(expr-thunked-if(1)) } }).println()

  println("Eval'ing function call (if/argument wrong arg no):")
  (error-handler { functions-handler { evaluate(expr-if-wrong-arg-no()) } }).println()
