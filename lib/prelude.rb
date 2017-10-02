module Prelude
  def apply(program)
    program + [
      Add,
      Sub,
      Mul,
      Div
    ]
  end
  module_function :apply

  BinOp = ->(name, ruby_func) do
    id_x, id_y = Identifier.new("x"), Identifier.new("y")
    FunDef.new(
      Identifier.new(name),
      FunCallArgs.new([id_x, id_y]),
      ->(programs, current_function) do
        program, env = programs
        finder = ->(id) { [program,env].flatten.find { |a| a.identifier == id } }
        fun_x, fun_y = finder[id_x], finder[id_y]
        x = run_eval(fun_x, programs)
        y = run_eval(fun_y, programs)
        ruby_func[x, y]
      end).tap do |fd|
        int = Domain.new(NumberType)
        fd.domains = Domains.new([int, int, int])
      end
  end

  Add = BinOp["add", ->(x, y) { x + y } ]
  Sub = BinOp["sub", ->(x, y) { x - y } ]
  Mul = BinOp["mul", ->(x, y) { x * y } ]
  Div = BinOp["div", ->(x, y) { x / y } ]
end
