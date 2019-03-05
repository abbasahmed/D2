# Map class that contains the map required to traverse during simulation
class Map
  # Constructor - store the name passed in as an argument
  def initialize
    @map = {
      'nil_town': %w[monkey_patch_city hash_crossing],
      'monkey_patch_city': %w[enumerable_canyon nil_town matzburg],
      'enumerable_canyon': %w[duck_type_beach monkey_patch_city],
      'duck_type_beach': %w[enumerable_canyon matzburg],
      'matzburg': %w[duck_type_beach hash_crossing dynamic_palisades monkey_patch_city],
      'hash_crossing': %w[matzburg dynamic_palisades nil_town],
      'dynamic_palisades': %w[hash_crossing matzburg]
    }
  end

  def neighbors(city)
    return nil if city.nil?

    @map.fetch(city.to_sym)
  rescue KeyError
    nil
  end

  def rubies(city)
    @max_real_rubies = 0
    @max_fake_rubies = 0
    case city
    when 'hash_crossing', 'dynamic_palisades', 'duck_type_beach'
      @max_real_rubies = 2
      @max_fake_rubies = 2
    when 'enumerable_canyon', 'monkey_patch_city'
      @max_real_rubies = 1
      @max_fake_rubies = 1
    when 'nil_town'
      @max_real_rubies = 0
      @max_fake_rubies = 3
    when 'matzburg'
      @max_real_rubies = 3
      @max_fake_rubies = 0
    else
      @max_real_rubies = -1
      @max_fake_rubies = -1
    end
    [@max_real_rubies, @max_fake_rubies]
  end
end
