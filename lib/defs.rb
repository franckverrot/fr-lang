class TypeDef < Struct.new(:identifier, :domains)
end

class Domain < Struct.new(:value)
  def to_s
    value
  end
end


class Domains < Struct.new(:values)
  def to_s
    "(#{values.map(&:to_s).join(', ')})"
  end
end

class FunDef
  attr_accessor :identifier, :body, :domains, :args
  def initialize(identifier, args, body)
    @identifier, @args, @body = identifier, args, body
    @domains = []
  end

  def to_s
    <<-EOS
(defn (##{identifier} :: #{domains.to_s})
  [#{args.value.map(&:to_s).join(', ')}]
  (#{body.to_s}))

EOS
  end
end

class FunCallArgs < Struct.new(:value)
  def to_s
    "#{value.map(&:to_s).join(', ')}"
  end
end

class FunArg < Struct.new(:value)
  def to_s
    "funarg:#{value}"
  end
end

class FunBody < Struct.new(:body)
  def to_s
    "#{body}"
  end
end

class Proc
  def to_s
    "<native_rb>"
  end
end

class Identifier < Struct.new(:name)
  def to_s
    "#{name}"
  end
end

class NumberType < Struct.new(:value)
  def to_s
    "n{#{value}}"
  end

  def +@
    self
  end

  def -@
    NumberType.new(- value)
  end

  def +(other)
    NumberType.new(value + other.value)
  end

  def -(other)
    NumberType.new(value - other.value)
  end

  def /(other)
    NumberType.new(value / other.value)
  end

  def *(other)
    NumberType.new(value * other.value)
  end
end

class StringType < Struct.new(:value)
  def to_s
    "s{#{value}}"
  end
end

class FunCall
  attr_accessor :identifier, :args
  def initialize(identifier, args = [])
    @identifier, @args = identifier, args
  end

  def to_s
    "#(#{identifier.to_s}[#{args.value.map(&:to_s).join(', ')}])"
  end
end
