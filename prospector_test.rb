require 'minitest/autorun'

require_relative 'prospector'
require_relative 'map'

class ProspectorTest < Minitest::Test
  def setup
    @m = Map.new
    @pt = Prospector.new(1)
  end

  # Creates a Prospector, refutes that it's nil, and asserts that it is a
  # kind of Prospector object.

  def test_new_prospector_not_nil
    refute_nil @pt
    assert_kind_of Prospector, @pt
  end

  # UNIT TESTS FOR METHOD mine(city)
  # Equivalence classes:
  # city or map does is nil -> returns nil
  # city exists in the hash -> return an array of random rubies and fake rubies that can be mined
  # empty string for city parameter -> returns nil
  # passing in an integer for city -> returns [-1, -1]

  # Verifies that nil parameters returns nil for mining array.
  def test_nil_params_mine
    assert_nil @pt.mine(@m, nil)
    assert_nil @pt.mine(nil, 'enumerable_canyon')
  end

  def test_valid_params_mine
    assert_operator @pt.mine(@m, 'hash_crossing')[0], :<=, 2
    assert_operator @pt.mine(@m, 'hash_crossing')[1], :<=, 2
    assert_equal @pt.mine(@m, 'nil_town')[0], 0
    assert_operator @pt.mine(@m, 'nil_town')[1], :<=, 3
  end

  # STUBBING

  def test_mine_map
    mock_map = Minitest::Mock.new('mocked_map')
    def mock_map.rubies(_param)
      [1, 1]
    end
    refute_nil @pt.mine(mock_map, 'nil_town')
  end

  # EDGE CASE
  def test_empty_string_mine
    assert_nil @pt.mine(@map, '')
  end

  # EDGE CASE
  def test_integer_for_city_mine
    assert_nil @pt.mine(@map, -1)
  end

  def test_print_start
    assert_output("\nRubyist #1 starting in Enumerable Canyon.\n") { @pt.print_start('Enumerable Canyon') }
  end

  # EDGE CASE
  def test_empty_print_start
    assert_nil(@pt.print_start(''))
  end

  # UNIT TESTS FOR METHOD emotion(total)
  # Equivalence classes:
  # total => -INFINITY.....0 - > Print information and "Going home empty handed"
  # total => 1.....9 - > Print information and "Going home sad"
  # total => 10....INFINITY - > Print information and "Going home victorious"
  def test_emotion_zero_rubies
    assert_output("\nGoing home empty-handed.\n") { @pt.emotion(0) }
  end

  def test_emotion_sad_rubies
    assert_output("\nGoing home sad.\n") { @pt.emotion(4) }
  end

  # EDGE CASE
  def test_emotion_nine_rubies
    assert_output("\nGoing home sad.\n") { @pt.emotion(9) }
  end

  def test_emotion_happy_rubies
    assert_output("\nGoing home victorious!\n") { @pt.emotion(13) }
  end

  def test_conclude_negative_days
    assert_nil(@pt.conclude(0, 0, -1))
  end

  def test_conclude_positive_values
    assert_output("\nAfter 2 days, Rubyist 1 found:\n\t 2 rubies.\n\t 2 fake rubies.") do
      @pt.conclude(2, 2, 2)
    end
  end
end
