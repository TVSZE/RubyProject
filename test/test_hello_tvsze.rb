# encoding: utf-8

require 'minitest'
require 'minitest/autorun'
require 'hello_tvsze'

class Hello_tvsze_Test < Minitest::Test
  def test_english_hello
    assert_equal "hello world",
                 Hello_tvsze.hi("english")
  end

  def test_any_hello
    assert_equal "hello world",
                 Hello_tvsze.hi("ruby")
  end

  def test_hungarian_hello
    assert_equal "Szia világ",
                 Hello_tvsze.hi("hungarian")
  end
end