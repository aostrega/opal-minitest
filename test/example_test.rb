class ExampleTest < Minitest::Test
  def test_passing_assert
    assert true
  end

  def test_failing_assert
    assert false, "intentional failure"
  end

  def test_skip
    skip "intentional skip"
  end
end
