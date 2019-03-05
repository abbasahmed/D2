require 'minitest/autorun'
require_relative 'simulator'

# Test for Simulator class
class SimulatorTest < Minitest::Test
  def setup
    @map = Map.new
    @prospector = Prospector.new('1')
  end

  # UNIT TESTS FOR METHOD simulator
  # Equivalence classes:
  # zero turns -> returns nil
  # negative turns -> returns nil
  # positive turns -> return number of rubies found >=0

  # Verifies that zero number of turns returns nil for its neighbors.
  def test_simulator_zero_turns
    @sim = Simulator.new(@map, @prospector, 0)
    assert_nil(@sim.simulate(true))
  end

  # STUBBING - Create a mock prospector, stub the mine function and run the simulator on positive no. of turns
  def test_simulator_positive_turns
    mock_dude = Minitest::Mock.new 'dude'
    def mock_dude.mine(_param, _param1)
      [[1, 1], [2, 2], [0, 0]].sample
    end

    result = Simulator.new(@map, mock_dude, 2).simulate(true)
    assert_operator(result[0], :>=, 0)
    assert_operator(result[1], :>=, 0)
  end

  # Verifies that negative number of turns returns nil for its neighbors.
  def test_simulator_negative_turn
    result = Simulator.new(@map, @prospector, -1).simulate(true)
    assert_nil(result)
  end

  # UNIT TESTS FOR METHOD print_switch(old_city, current_city)
  # Equivalence classes:
  # valid input -> returns Heading from <old_city> to <current_city>
  # empty string for old_city -> returns nil, prints nothing
  # empty string for current_city -> returns nil, prints nothing

  # Verifies that valid city inputs prints the right statement.
  def test_print_switch_valid
    assert_output('Heading from Pitt to New York') do
      Simulator.new(@map, @prospector, 2).print_switch('Pitt', 'New York')
    end
  end

  # Verifies that invalid old city name input prints nothing
  def test_print_switch_empty_a
    result = Simulator.new(@map, @prospector, 2).print_switch('', 'nowhere')
    assert_nil(result)
  end

  # Verifies that invalid current city name input prints nothing
  def test_print_switch_empty_b
    result = Simulator.new(@map, @prospector, 2).print_switch('nowhere', '')
    assert_nil(result)
  end

  # UNIT TESTS FOR METHOD switch_city(map, city)
  # Equivalence classes:
  # valid city -> returns a new city, which is a neighbor of old city
  # invalid city -> returns nil

  # STUBBING - verify that a city is being switched by mocking a map and stubbing the neighbors
  def test_switch_valid_city
    mock_map = Minitest::Mock.new 'mock_map'
    def mock_map.neighbors(_param)
      %w[oakland shadyside]
    end
    next_city = Simulator.new(@map, @prospector, 2).switch_city(mock_map, 'southside')
    assert_includes %w[oakland shadyside], next_city
  end

  # verify that an invalid city name returns nothing
  def test_switch_invalid_city
    next_city = Simulator.new(@map, @prospector, 2).switch_city(@map, 'monkey_patch')
    assert_nil  next_city
  end

  # UNIT TESTS FOR METHOD print_rubies(real, fake, city)
  # Equivalence classes:
  # Real=0, Fake=0        -> print: Found no rubies or fake rubies in <city>.
  # Real=0, Fake>1        -> print: Found 'n' fake rubies in <city>.
  # Real>1, Fake=0        -> print: Found 'n' rubies in <city>.
  # Real=1, Fake=1        -> print: Found 1 ruby and 1 fake ruby in <city>.
  # Real>1, Fake>1        -> print: Found 'n' rubies and 'n' rubies in <city>.
  # Real, Fake not valid  -> print: Nothing Found

  # verify when real = 0, fake = 0, it print neither rubies are found in city
  def test_rubies_zero
    assert_output("\n\tFound no rubies or fake rubies in Matzburg.") do
      Simulator.new(@map, @prospector, 2).print_rubies(0, 0, 'matzburg')
    end
  end

  # verify when real = 0, fake>1, it prints only fake rubies found
  def test_rubies_only_fake_found
    assert_output("\n\tFound 2 fake rubies in Matzburg.") do
      Simulator.new(@map, @prospector, 2).print_rubies(0, 2, 'matzburg')
    end
  end

  # verify when real>1, fake = 0, it prints only real rubies found
  def test_rubies_only_real_found
    assert_output("\n\tFound 2 rubies in Monkey Patch City.") do
      Simulator.new(@map, @prospector, 2).print_rubies(2, 0, 'monkey_patch_city')
    end
  end

  # verify when real=1, fake = 1, it prints singular ruby found of each kind
  def test_rubies_singular
    assert_output("\n\tFound 1 ruby and 1 fake ruby in Matzburg.") do
      Simulator.new(@map, @prospector, 2).print_rubies(1, 1, 'matzburg')
    end
  end

  # verify when real>1, fake>1, it prints rubies found of each kind in plural form
  def test_rubies_plural
    assert_output("\n\tFound 2 rubies and 2 fake rubies in Matzburg.") do
      Simulator.new(@map, @prospector, 2).print_rubies(2, 2, 'matzburg')
    end
  end

  # EDGE CASE - when negative values are passed in for rubies, it should print that nothing is found.
  def test_rubies_negative
    assert_output("\n\tFound no rubies or fake rubies in Matzburg.") do
      Simulator.new(@map, @prospector, 2).print_rubies(-1, -1, 'matzburg')
    end
  end

  # UNIT TESTS FOR METHOD pretty_print(city)
  # Equivalence classes:
  # underscores           -> returns the city name word split by underscores
  # first letters         -> returns the city name with each word capitalized
  # Invalid input         -> returns nil

  # verify whether a string is being capitalized by first letter
  def test_pretty_print_capitalize
    assert_equal 'Matzburg', Simulator.new(@map, @prospector, 2).pretty_print('matzburg')
  end

  # verify whether a string is being split by underscores
  def test_pretty_print_underscores
    assert_equal 'Nil Town', Simulator.new(@map, @prospector, 2).pretty_print('nil_town')
  end

  # EDGE CASE - when nothing is passed in, nothing should be returned, nil
  def test_pretty_print_nothing
    assert_nil Simulator.new(@map, @prospector, 2).pretty_print('')
  end
end
