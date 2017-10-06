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

  def empty?
    values.empty?
  end
end

class UnknownArgType < Struct.new(:identifier)
  def to_s
    "<unknown type>"
  end
end

class FunDef
  attr_accessor :identifier, :body, :domains, :args
  def initialize(identifier, args, body, domains = Domains.new([]))
    @identifier, @args, @body = identifier, args, body
    @domains = if domains.values.empty?
                 Domains.new(
                   args.value.map do |arg|
                     Domain.new(UnknownArgType.new(arg))
                   end)
               else
                 domains
               end
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

class NativeRubyCode < Struct.new(:name, :body, :domains)
  def to_s
    "#<native(#{name} :: #{domains.to_s}>"
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

class UnknownType
end
