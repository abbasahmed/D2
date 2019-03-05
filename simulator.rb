require_relative 'prospector'
# Simulator class containing methods for running a simulation on the map by the prospector
class Simulator
  # constructor
  def initialize(map, prospector, num_turns)
    @map = map
    @prospector = prospector
    @num_turns = num_turns
    @real_ruby = 0
    @fake_ruby = 0
    @days = 0
  end

  # simulator function which takes in tester boolean to avoid printing statements when the code is being tested
  def simulate(tester)
    return nil if @num_turns < 1

    current_city = 'enumerable_canyon'
    @prospector.print_start(pretty_print(current_city)) unless tester
    current_rubies = @prospector.mine(@map, current_city)
    i = 0
    until i >= @num_turns
      @days += 1
      @real_ruby += current_rubies[0]
      @fake_ruby += current_rubies[1]
      print_rubies(current_rubies[0], current_rubies[1], current_city) unless tester
      if current_rubies[0].zero? && current_rubies[1].zero?
        old_city = current_city
        current_city = switch_city(@map, current_city)
        i += 1
        print_switch(old_city, current_city) if i < @num_turns && !tester
      end
      current_rubies = @prospector.mine(@map, current_city) if i < @num_turns
    end
    @prospector.conclude(@real_ruby, @fake_ruby, @days) unless tester
    @prospector.emotion(@real_ruby + @fake_ruby) unless tester
    [@real_ruby, @fake_ruby]
  end

  # helper function to print the switch between cities
  def print_switch(old_city, current_city)
    return nil if old_city.empty? || current_city.empty?

    print("Heading from #{pretty_print old_city} to #{pretty_print current_city}")
  end

  # helper function to switch to next city depending on the neighbors
  def switch_city(map, city)
    return nil if map.nil? || city.nil?

    list = map.neighbors(city)
    return nil if list.nil?

    index = rand(list.size)
    list[index]
  end

  # helper function to print how many rubies are found in each run
  def print_rubies(real, fake, city)
    real = 0 if real < 0

    fake = 0 if fake < 0

    print_statement = "\n\tFound"

    if real.zero? && fake.zero?
      print_statement += " no rubies or fake rubies in #{pretty_print city}."
      print(print_statement)
      return
    end

    case real
    when 0
      nil
    when 1
      print_statement += " #{real} ruby"
    else
      print_statement += " #{real} rubies"
    end

    print_statement += ' and' if real != 0 && fake != 0

    case fake
    when 0
      nil
    when 1
      print_statement += " #{fake} fake ruby"
    else
      print_statement += " #{fake} fake rubies"
    end

    print_statement += " in #{pretty_print city}."
    print(print_statement)
  end

  # helper function which splits the word by underscores and capitalizes the first letter of each word
  def pretty_print(city_name)
    return nil if city_name.empty?

    pretty_city = city_name.split('_').join(' ')
    pretty_city.split.each(&:capitalize!).join(' ')
  end
end
