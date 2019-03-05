require 'minitest/autorun'
require_relative 'prospector'
require_relative 'map'

# Test class for Prospector.rb file
class ProspectorTest < Minitest::Test
  def setup
    @map = Map.new
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
  # city or map is nil -> returns nil
  # city exists in the hash -> return an array of random rubies and fake rubies that can be mined
  # invalid input for city parameter -> returns nil

  # Verifies that nil parameters returns nil for mining array.
  def test_nil_params_mine
    assert_nil @pt.mine(@map, nil)
    assert_nil @pt.mine(nil, 'enumerable_canyon')
  end

  # verifies that valid parameters return an array of random rubies for max>= real >=0 and max>= fake >=0
  def test_valid_params_mine
    assert_operator @pt.mine(@map, 'hash_crossing')[0], :<=, 2
    assert_operator @pt.mine(@map, 'hash_crossing')[1], :<=, 2
    assert_equal @pt.mine(@map, 'nil_town')[0], 0
    assert_operator @pt.mine(@map, 'nil_town')[1], :<=, 3
  end

  # STUBBING - creates a mock map and stubs the rubies function to return [1, 1]. Mining should not return nil.
  def test_mine_map
    mock_map = Minitest::Mock.new('mocked_map')
    def mock_map.rubies(_param)
      [1, 1]
    end
    refute_nil @pt.mine(mock_map, 'nil_town')
  end

  # EDGE CASE - checks whether an empty string returns nil
  def test_empty_string_mine
    assert_nil @pt.mine(@map, '')
  end

  # EDGE CASE - checks whether an invalid input, not string, returns nil
  def test_integer_for_city_mine
    assert_nil @pt.mine(@map, -1)
  end

  # UNIT TESTS FOR METHOD print_start(city)
  # Equivalence classes:
  # city is valid -> returns Rubyist <name> starting in <city>.
  # city is invalid ->return nil

  # verify that passing a city name will print the right statement
  def test_print_start
    assert_output("\nRubyist #1 starting in Enumerable Canyon.\n") { @pt.print_start('Enumerable Canyon') }
  end

  # EDGE CASE - verify that empty string will return nil
  def test_empty_print_start
    assert_nil(@pt.print_start(''))
  end

  # UNIT TESTS FOR METHOD emotion(total)
  # Equivalence classes:
  # total => -INFINITY.....0 - > Print information and "Going home empty handed"
  # total => 1.....9 - > Print information and "Going home sad"
  # total => 10....INFINITY - > Print information and "Going home victorious"

  # verify whether prospector is going home empty handed for negative values
  def test_emotion_negative_rubies
    assert_output("\nGoing home empty-handed.\n") { @pt.emotion(0) }
  end

  # EDGE CASE - Check whether prospector is going home empty handed for zero rubies
  def test_emotion_zero_rubies
    assert_output("\nGoing home empty-handed.\n") { @pt.emotion(0) }
  end

  # Check whether prospector is going home sad for <9 rubies
  def test_emotion_sad_rubies
    assert_output("\nGoing home sad.\n") { @pt.emotion(4) }
  end

  # EDGE CASE - Check whether prospector is going home sad for 9 rubies
  def test_emotion_nine_rubies
    assert_output("\nGoing home sad.\n") { @pt.emotion(9) }
  end

  # Check whether prospector is going home victorious for >9 rubies
  def test_emotion_happy_rubies
    assert_output("\nGoing home victorious!\n") { @pt.emotion(13) }
  end

  # UNIT TESTS FOR METHOD conclude(real, fake, days)
  # Equivalence classes:
  # positive values - > return a summary of real, fake rubies found and no. of days taken
  # negative days - > return nil

  # verify whether negative days return nil
  def test_conclude_negative_days
    assert_nil(@pt.conclude(0, 0, -1))
  end

  # verify whether positive values return a short summary
  def test_conclude_positive_values
    assert_output("\nAfter 2 days, Rubyist 1 found:\n\t 2 rubies.\n\t 2 fake rubies.") do
      @pt.conclude(2, 2, 2)
    end
  end
end
