# Prospector class that includes the mining ability and to notify start and finish
class Prospector
  def initialize(name)
    @name = name
  end

  # method to mine random rubies from a city within the map
  def mine(map, city)
    return nil if map.nil? || city.nil?

    rubies = map.rubies(city)
    return nil if rubies == [-1, -1]

    real_mined = rand(rubies[0] + 1)
    fake_mined = rand(rubies[1] + 1)

    [real_mined, fake_mined]
  end

  # helper method to announce the start of mining
  def print_start(city)
    return nil if city.nil? || city.empty?

    print("\nRubyist ##{@name} starting in #{city}.\n")
  end

  # helper method to announce the retirement of the prospector and his experience of the ruby mining
  def conclude(real, fake, days)
    return nil if days < 1 || @name.nil?

    print("\nAfter #{days} days, Rubyist #{@name} found:")
    print("\n\t #{real} rubies.")
    print("\n\t #{fake} fake rubies.")
  end

  # helper to decide the emotion of prospector after mining rubies.
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
