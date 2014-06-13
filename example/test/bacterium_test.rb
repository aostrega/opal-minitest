class BacteriumTest < MiniTest::Test
  def setup
    @object = Bacterium.new
  end

  def test_reproduce_returns_genetic_clone
    assert_equal(@object.reproduce.class, @object.class)
  end
end
