require_relative 'prospector'
# Simulator class containing methods for running a simulation on the map by the prospector
class Simulator
  def initialize(map, prospector, num_turns)
    @map = map
    @p = prospector
    @num_turns = num_turns
    @real_ruby = 0
    @fake_ruby = 0
    @days = 0
  end

  def simulate(tester)
    return nil if @num_turns < 1

    current_city = 'enumerable_canyon'
    @p.print_start(pretty_print(current_city)) unless tester
    current_rubies = @p.mine(@map, current_city)
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
      current_rubies = @p.mine(@map, current_city) if i < @num_turns
    end
    @p.conclude(@real_ruby, @fake_ruby, @days) unless tester
    @p.emotion(@real_ruby + @fake_ruby) unless tester
    [@real_ruby, @fake_ruby]
  end

  def print_switch(old_city, current_city)
    return nil if old_city.empty? || current_city.empty?

    print("Heading from #{pretty_print old_city} to #{pretty_print current_city}")
  end

  def switch_city(map, city)
    return nil if map.nil? || city.nil?

    list = map.neighbors(city)
    index = rand(list.size)
    list[index]
  end

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

  def pretty_print(city_name)
    pretty_city = city_name.split('_').join(' ')
    pretty_city.split.each(&:capitalize!).join(' ')
  end
end
