require_relative 'map'
require_relative 'prospector'
begin
  if ARGV.count != 3 || ((ARGV[1]).to_i <= 0) || ((ARGV[2]).to_i <= 0)
    print("
          Usage:
          ruby ruby_rush.rb *seed* *num_prospectors* *num_turns*
          *seed* should be an integer
          *num_prospectors* should be a non-negative integer
          *num_turns* should be a non-negative integer\n")
    exit(1)
  end
  @seed = Integer(ARGV[0])
  @num_prospectors = Integer(ARGV[1])
  @num_turns = Integer(ARGV[2])
  @map = Map.new
  srand(@seed)
  (1..@num_prospectors).each { |i| Prospector.new(@map, @num_turns, i, @seed).simulate }
end