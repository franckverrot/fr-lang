module Prelude
  def apply(program)
    program + [
      BinOp["add", ->(x, y) { x + y } ],
      BinOp["sub", ->(x, y) { x - y } ],
      BinOp["mul", ->(x, y) { x * y } ],
      BinOp["div", ->(x, y) { x / y } ]
    ]
  end
  module_function :apply

  BinOp = ->(name, ruby_func) do
    id_x, id_y = Identifier.new("x"), Identifier.new("y")
    int_type = Domain.new(NumberType)
    FunDef.new(
      Identifier.new(name),
      FunCallArgs.new([id_x, id_y]),
      NativeRubyCode.new(
        name,
        ->(programs, current_function) do
          program, env = programs
          finder = ->(id) { [program,env].flatten.find { |a| a.identifier == id } }
          fun_x, fun_y = finder[id_x], finder[id_y]
          x = run_eval(fun_x, programs)
          y = run_eval(fun_y, programs)
          ruby_func[x, y]
        end,
        Domains.new([int_type, int_type, int_type])
      ),
      Domains.new([int_type, int_type, int_type]))
  end
end
