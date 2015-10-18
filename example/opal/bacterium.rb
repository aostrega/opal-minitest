class Bacterium
  attr_accessor :food

  def initialize
    @food = []
  end

  def reproduce
    self.class.new
  end

  def eat(object)
    food << object
  end
end
