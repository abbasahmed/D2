require 'minitest/autorun'

require_relative 'prospector'
require_relative 'map'

class ProspectorTest < Minitest::Test
  def setup
    @map = Map.new
    @pt = Prospector.new(@map, 2, 1, 3)
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
    assert_nil @pt.mine(@map, nil)
    assert_nil @pt.mine(nil, 'enumerable_canyon')
  end

  def test_valid_params_mine
    assert_operator @pt.mine(@map, 'hash_crossing')[0], :<=, 2
    assert_operator @pt.mine(@map, 'hash_crossing')[1], :<=, 2
    assert_equal @pt.mine(@map, 'nil_town')[0], 0
    assert_operator @pt.mine(@map, 'nil_town')[1], :<=, 3
  end

  def test_empty_string_for_city_mine
    assert_nil @pt.mine(@map, '')
  end

  # EDGE CASE
  def test_integer_for_city_mine
    assert_nil @pt.mine(@map, -1)
  end

  # UNIT TESTS FOR METHOD simulate(city)
  # Equivalence classes:

end
