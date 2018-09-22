class Rational < Numeric
  def initialize(numerator = 0, denominator = 1)
    @numerator = numerator
    @denominator = denominator

    _simplify
  end

  def inspect
    "(#{to_s})"
  end

  def to_s
    "#{numerator}/#{denominator}"
  end

  def *(rhs)
    if rhs.is_a? Rational
      Rational(numerator * rhs.numerator, denominator * rhs.denominator)
    elsif rhs.is_a? Integer
      Rational(numerator * rhs, denominator)
    elsif rhs.is_a? Numeric
      numerator * rhs / denominator
    end
  end

  def +(rhs)
    if rhs.is_a? Rational
      Rational(numerator * rhs.denominator + rhs.numerator * denominator, denominator * rhs.denominator)
    elsif rhs.is_a? Integer
      Rational(numerator + rhs * denominator, denominator)
    elsif rhs.is_a? Numeric
      (numerator + rhs * denominator) / denominator
    end
  end

  def -(rhs)
    if rhs.is_a? Rational
      Rational(numerator * rhs.denominator - rhs.numerator * denominator, denominator * rhs.denominator)
    elsif rhs.is_a? Integer
      Rational(numerator - rhs * denominator, denominator)
    elsif rhs.is_a? Numeric
      (numerator - rhs * denominator) / denominator
    end
  end

  def /(rhs)
    if rhs.is_a? Rational
      Rational(numerator * rhs.denominator, denominator * rhs.numerator)
    elsif rhs.is_a? Integer
      Rational(numerator, denominator * rhs)
    elsif rhs.is_a? Numeric
      numerator / rhs / denominator
    end
  end

  def negative?
    numerator.negative?
  end

  def _simplify
    a = numerator
    b = denominator
    a, b = b, a % b while !b.zero?
    @numerator /= a
    @denominator /= a
  end

  attr_reader :numerator, :denominator
end

def Rational(numerator = 0, denominator = 1)
  Rational.new(numerator, denominator)
end

[Fixnum, Float].each do |cls|
  [:+, :-, :*, :/, :==].each do |op|
    cls.instance_exec do
      original_operator_name = "__original_operator_#{op}_rational"
      alias_method original_operator_name, op
      define_method op do |rhs|
        if rhs.is_a? Rational
          Rational(self).send(op, rhs)
        else
          send(original_operator_name, rhs)
        end
      end
    end
  end
end