require 'bacterium'

class BacteriumTest < Minitest::Test
  def setup
    @bacterium = Bacterium.new
  end

  def test_reproduce_returns_clone
    assert_equal(@bacterium.reproduce.class, @bacterium.class)
  end

  def test_eat_adds_bacterium_to_food
    object = Object.new
    @bacterium.eat(object)
    assert_includes(@bacterium.food, object)
  end
end
