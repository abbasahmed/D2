require 'minitest/autorun'
require_relative 'simulator'

# Test for Simulator class
class SimulatorTest < Minitest::Test
  def setup
    @map = Map.new
    @prospector = Prospector.new('1')
  end

  def test_simulator_zero_turns
    @sim = Simulator.new(@map, @p, 0)
    assert_nil(@sim.simulate(true))
  end

  def test_simulator_positive_turns
    mock_dude = Minitest::Mock.new 'dude'
    def mock_dude.mine(_param, _param1)
      [[1, 1], [2, 2], [0, 0]].sample
    end

    result = Simulator.new(@map, mock_dude, 2).simulate(true)
    assert_operator(result[0], :>=, 0)
    assert_operator(result[1], :>=, 0)
  end

  def test_simulator_negative_turn
    result = Simulator.new(@map, @prospector, -1).simulate(true)
    assert_nil(result)
  end

  def test_print_switch_valid
    assert_output('Heading from Pitt to New York') do
      Simulator.new(@map, @prospector, 2).print_switch('Pitt', 'New York')
    end
  end

  def test_print_switch_empty_a
    result = Simulator.new(@map, @prospector, 2).print_switch('', 'nowhere')
    assert_nil(result)
  end

  def test_print_switch_empty_b
    result = Simulator.new(@map, @prospector, 2).print_switch('nowhere', '')
    assert_nil(result)
  end

  # STUB
  def test_switch_valid_city
    mock_map = Minitest::Mock.new 'mock_map'
    def mock_map.neighbors(_param)
      %w[oakland shadyside]
    end
    next_city = Simulator.new(@map, @prospector, 2).switch_city(mock_map, 'southside')
    assert_includes %w[oakland shadyside], next_city
  end

  def test_switch_invalid_city
    next_city = Simulator.new(@map, @prospector, 2).switch_city(@map, 'monkey_patch_city')
    assert_includes %w[enumerable_canyon nil_town matzburg], next_city
  end

  def test_rubies_zero
    assert_output("\n\tFound no rubies or fake rubies in Matzburg.") do
      Simulator.new(@map, @prospector, 2).print_rubies(0, 0, 'matzburg')
    end
  end

  def test_rubies_only_fake_found
    assert_output("\n\tFound 2 fake rubies in Matzburg.") do
      Simulator.new(@map, @prospector, 2).print_rubies(0, 2, 'matzburg')
    end
  end

  def test_rubies_only_real_found
    assert_output("\n\tFound 2 rubies in Monkey Patch City.") do
      Simulator.new(@map, @prospector, 2).print_rubies(2, 0, 'monkey_patch_city')
    end
  end

  def test_rubies_singular
    assert_output("\n\tFound 1 ruby and 1 fake ruby in Matzburg.") do
      Simulator.new(@map, @prospector, 2).print_rubies(1, 1, 'matzburg')
    end
  end

  def test_rubies_plural
    assert_output("\n\tFound 2 rubies and 2 fake rubies in Matzburg.") do
      Simulator.new(@map, @prospector, 2).print_rubies(2, 2, 'matzburg')
    end
  end

  # EDGE CASE

  def test_rubies_negative
    assert_output("\n\tFound no rubies or fake rubies in Matzburg.") do
      Simulator.new(@map, @prospector, 2).print_rubies(-1, -1, 'matzburg')
    end
  end

  def test_pretty_print_capitalize
    assert_equal 'Matzburg', Simulator.new(@map, @prospector, 2).pretty_print('matzburg')
  end

  def test_pretty_print_underscores
    assert_equal 'Nil Town', Simulator.new(@map, @prospector, 2).pretty_print('nil_town')
  end

  # EDGE CASE
  def test_pretty_print_nothing
    assert_equal '', Simulator.new(@map, @prospector, 2).pretty_print('')
  end
end
