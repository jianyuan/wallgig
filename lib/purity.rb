class Purity
  include Comparable

  VALUES = [:sfw, :sketchy, :nsfw]

  attr_reader :value

  def initialize(purity)
    purity  = purity.to_sym
    @purity = purity if VALUES.include?(purity)
    @value  = VALUES.index(@purity)
  end

  VALUES.each do |purity|
    define_method "#{purity}?" do
      @purity == purity
    end
  end

  def safer_than?(other)
    self < other
  end

  def sketchier_than?(other)
    self > other
  end

  def <=>(other)
    self.value <=> other.value
  end

  def to_s
    @purity.to_s
  end
end
