class Parser
  prechigh
    nonassoc UMINUS
    left '*' '/'
    left '+' '-'
  preclow
rule
  target: statements
        | /* none */ { @env = {} }

  statements: statement
            | statements nl statement { result = val.flatten.compact }
  statement: typedef { result = val }
           | fun { result = val }

  nl: NEWLINE

  fun_name: IDENTIFIER { result = Identifier.new(val.first) }

  typedef: IDENTIFIER TYPEDEF domains { result = TypeDef.new val[0], val[2] }

  domains: domain {  result = val.flatten }
         | domains ARROW domain {  result = [result, val[2]].flatten }
         | { binding.pry; result = [] }

  domain: TYPE

  fun: fun_name EQ fun_body { result = FunDef.new(val[0], FunCallArgs.new([]), val[2]) }
     | fun_name fun_args EQ fun_body { result = FunDef.new(val[0], val[1], val[3]) }

  fun_args: fun_arg { result = FunCallArgs.new(val) }
          | fun_args fun_arg { result = FunCallArgs.new([result.value,val[1]].flatten) }

  fun_arg: IDENTIFIER { result = Identifier.new(val.first) }

  fun_body: QUOTED_STRING { result = StringType.new(val.first) }
          | fun_call { result = val[0] }
          | exp { result = val[0]}

  exp: exp bin_op exp { result = FunCall.new(val[1], FunCallArgs.new([val[0], val[2]])) } #todo: typing
     | '(' exp ')' { result = val[1] }
     | '-' NUMBER  =UMINUS { result = -val[1] }
     | NUMBER { result = NumberType.new(val.first) }
     | fun_call
  bin_op: '+' { result = Identifier.new("add") }
        | '-' { result = Identifier.new("sub") }
        | '*' { result = Identifier.new("mul") }
        | '/' { result = Identifier.new("div") }

  fun_call: fun_name fun_call_args { result = FunCall.new(val[0], val[1]) }
  fun_call_args: exp { result = FunCallArgs.new(val) }
               | fun_call_args exp { result = FunCallArgs.new([result.value, val[1]].flatten) }
               | /* nothing */ { result = FunCallArgs.new([]) }
end

---- inner
  def parse(str)
    @q = []
    until str.empty?
      case str
      when /\A->/
        s = $&
        @q.push [:ARROW, s]
      when /\A".*"/
        s = $&
        @q.push [:QUOTED_STRING, s]
      when /\A[A-Z][a-z0-9]+/
        s = $&
        @q.push [:TYPE, s]
      when /\A[a-z]([a-zA-Z0-9_'])*/
        s = $&
        @q.push [:IDENTIFIER, s]
      when /\A\s*=\s*/
        s = $&
        @q.push [:EQ, s]
      when /\A::/
        @q.push [:TYPEDEF, "::"]
      when /\A\n+/
        @q.push [:NEWLINE, nil]
      when /\A\s+/
      when /\A\d+/
        @q.push [:NUMBER, $&.to_i]
      when /\A.|\n/o
        s = $&
        @q.push [s, s]
      end
      str = $'
    end
    @q.push [false, '$end']
    do_parse
  end

  def next_token
    @q.shift
  end

#
---- footer

