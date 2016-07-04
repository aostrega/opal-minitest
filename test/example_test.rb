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

  def test_capture_io
    out, err = capture_io do
      puts 'woo'
      warn 'boo'
    end

    assert_match 'woo', out
    assert_match 'boo', err
  end
end
