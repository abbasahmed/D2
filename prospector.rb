class Prospector
  def initialize(map, num_turns, name, seed)
    @map = map
    @num_turns = num_turns
    @name = name
    @real_ruby = 0
    @fake_ruby = 0
    @days = 0
    @seed = seed
  end

  def print_rubies(real, fake, city)
    print_statement = "\n\tFound"

    if real.zero? && fake.zero?
      print_statement += " no rubies or fake rubies in #{pretty_print city}\n"
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

  def mine(map, city)
    rubies = map.rubies(city)
    real_mined = rand(rubies[0] + 1)
    fake_mined = rand(rubies[1] + 1)
    [real_mined, fake_mined]
  end

  def simulate
    return nil if @num_turns < 1

    print("\nRubyist ##{@name} starting in Enumerable Canyon.\n")
    current_city = 'enumerable_canyon'
    current_rubies = mine(@map, current_city)
    i = 0
    until i >= @num_turns
      @days += 1
      @real_ruby += current_rubies[0]
      @fake_ruby += current_rubies[1]
      print_rubies(current_rubies[0], current_rubies[1], current_city)
      if current_rubies[0].zero? && current_rubies[1].zero?
        old_city = current_city
        current_city = switch_city(@map, current_city)
        i += 1
        print("Heading from #{pretty_print old_city} to #{pretty_print current_city}") if i < @num_turns
      end
      current_rubies = mine(@map, current_city)
    end
    finish_simulation(@real_ruby, @fake_ruby, @days, @name)
  end

  def finish_simulation(real, fake, days, name)
    return nil if days < 1 || name.nil?

    print("\nAfter #{days} days, Rubyist #{name} found:")
    print("\n\t #{real} rubies.")
    print("\n\t #{fake} fake rubies.")

    if real + fake <= 0
      print "\nGoing home empty-handed.\n"
    elsif real + fake <= 9
      print "\nGoing home sad.\n"
    else
      print "\nGoing home victorious!\n"
    end
  end

  def switch_city(map, city)
    list = map.neighbors(city)
    index = rand(list.size)
    list[index]
  end

  def pretty_print(city_name)
    pretty_city = city_name.split('_').join(' ')
    pretty_city.split.each(&:capitalize!).join(' ')
  end
end
