require_relative 'mock_lobster.rb'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class User
  def hello
    "hi"
  end
end

ME = User.new

class MockLobsterTest < Minitest::Test
  def test_minitest_works
    assert_equal ME.hello, "hi"

    mock = mock(:yo => "yo")
    assert_equal mock.yo, "yo"

    ME.stubbify(:hello => "goodbye")
    assert_equal ME.hello, "goodbye"
  end

  def test_it_auto_teardowns
    assert_equal ME.hello, "hi"
  end
end
