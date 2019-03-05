require 'minitest/autorun'
require_relative 'map'

# test class for map
class MapTest < Minitest::Test
  def setup
    @map = Map.new
  end

  # Creates a map, refutes that it's nil, and asserts that it is a
  # kind of Map object.

  def test_new_map_not_nil
    refute_nil @map
    assert_kind_of Map, @map
  end

  # UNIT TESTS FOR METHOD neighbors(city)
  # Equivalence classes:
  # city does not exist -> returns nil
  # city exists in the hash -> return an array of neighbor cities
  # empty string for city parameter -> returns nil

  # Verifies that an invalid city returns nil for its neighbors.
  def test_invalid_city_neighbors
    fake_city = 'enumerable_pittsburgh'
    assert_nil @map.neighbors(fake_city)
  end

  # Verifies that a valid city returns proper neighbors.
  def test_valid_city_neighbors
    city1 = 'enumerable_canyon'
    neighbors1 = %w[duck_type_beach monkey_patch_city]
    city2 = 'monkey_patch_city'
    neighbors2 = %w[enumerable_canyon nil_town matzburg]
    city3 = 'dynamic_palisades'
    neighbors3 = %w[hash_crossing matzburg]
    assert_equal @map.neighbors(city1), neighbors1
    assert_equal @map.neighbors(city2), neighbors2
    assert_equal @map.neighbors(city3), neighbors3
  end

  # Verifies that an empty string returns nil for its neighbors.
  # EDGE CASE
  def test_empty_string_neighbors
    assert_nil @map.neighbors('')
  end

  # UNIT TESTS FOR METHOD rubies(city)
  # Equivalence classes:
  # city does not exist -> returns [-1, -1]
  # city exists in the hash -> returns an array containing the max number of real rubies, fake rubies, e.g. [2,2]
  # empty string for city parameter -> returns nil

  # Verifies that an invalid city name returns negative values for real and fake rubies.
  def test_invalid_city_rubies
    assert_equal @map.rubies('pittsburgh'), [-1, -1]
    assert_equal @map.rubies(''), [-1, -1]
  end

  # Verifies that a valid city returns proper values for max real and fake rubies.
  def test_valid_city_rubies
    assert_equal @map.rubies('enumerable_canyon'), [1, 1]
    assert_equal @map.rubies('hash_crossing'), [2, 2]
    assert_equal @map.rubies('matzburg'), [3, 0]
    assert_equal @map.rubies('nil_town'), [0, 3]
  end

  # Verifies that nil returns negative values for its rubies.
  def test_nil_rubies
    assert_equal @map.rubies(nil), [-1, -1]
  end
end
