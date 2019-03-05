class Prospector
  def initialize(name)
    @name = name
  end

  def mine(map, city)
    return nil if map.nil? || city.nil?

    rubies = map.rubies(city)
    return nil if rubies == [-1, -1]

    real_mined = rand(rubies[0] + 1)
    fake_mined = rand(rubies[1] + 1)

    [real_mined, fake_mined]
  end

  def print_start(city)
    return nil if city.nil? || city.size < 1

    print("\nRubyist ##{@name} starting in #{city}.\n")
  end

  # Returns concatenated version of all vars.
  # SUCCESS CASES: All variables are valid and contain something that can be stringified
  # FAILURE CASES: If any variable is nil, that area is blank
  #                If days < 1 or name is nil, will return nil

  # REFERENCED METHOD

  def conclude(real, fake, days)
    return nil if days < 1 || @name.nil?

    print("\nAfter #{days} days, Rubyist #{@name} found:")
    print("\n\t #{real} rubies.")
    print("\n\t #{fake} fake rubies.")

  end

  def emotion(total)
    if total <= 0
      print "\nGoing home empty-handed.\n"
    elsif total <= 9
      print "\nGoing home sad.\n"
    else
      print "\nGoing home victorious!\n"
    end
  end
end
