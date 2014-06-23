require 'bacterium'

class BacteriumTest < Minitest::Test
  def setup
    @object = Bacterium.new
  end

  def test_reproduce_returns_genetic_clone
    assert_equal(@object.reproduce.class, @object.class)
  end

  def test_intentional_failure
    assert_equal(6, 7)
  end
end
