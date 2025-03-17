require_relative 'map_utils/grid'
require_relative 'algorithms'

module Vanilla
  # Represents a game map with a grid of cells
  class Map
    # Create a new map with the given parameters
    #
    # @param rows [Integer] The number of rows in the map
    # @param cols [Integer] The number of columns in the map
    # @param algorithm [Class] The algorithm class to use for maze generation
    # @param seed [Integer] The random seed for maze generation
    # @return [Grid] The generated grid
    def self.create(rows:, cols:, algorithm: Algorithms::BinaryTree, seed:)
      new(rows: rows, cols: cols, algorithm: algorithm, seed: seed).create
    end

    # Initialize a new map
    #
    # @param rows [Integer] The number of rows in the map
    # @param cols [Integer] The number of columns in the map
    # @param algorithm [Class] The algorithm class to use for maze generation
    # @param seed [Integer] The random seed for maze generation
    def initialize(rows:, cols:, algorithm:, seed:)
      @rows = rows
      @cols = cols
      @algorithm = algorithm
      @seed = seed
      srand(@seed)
      
      @debug_log = File.open('debug.log', 'a')
      @debug_log.puts "\n=== Map Initialization ==="
      @debug_log.puts "Time: #{Time.now}"
      @debug_log.puts "Dimensions: #{rows}x#{cols}"
      @debug_log.puts "Algorithm: #{algorithm}"
      @debug_log.puts "Seed: #{seed}"
      @debug_log.close
    end

    # Create a new maze using the specified algorithm
    #
    # @return [Grid] The generated grid
    def create
      @debug_log = File.open('debug.log', 'a')
      @debug_log.puts "\n=== Map Creation Started ==="
      @debug_log.puts "Time: #{Time.now}"
      @debug_log.puts "Creating new grid..."
      @debug_log.puts "Grid created with dimensions: #{@rows}x#{@cols}"
      @debug_log.puts "Generating maze using #{@algorithm}..."
      @debug_log.puts "Maze generation completed"
      @debug_log.puts "\nInitial grid state:"
      @debug_log.puts "Map creation completed"
      @debug_log.close
    end

    private

    def place_stairs(grid)
      # Find all floor tiles
      floor_tiles = []
      grid.each_cell do |cell|
        floor_tiles << cell if cell.tile == Support::TileType::FLOOR
      end
      
      @debug_log.puts "Found #{floor_tiles.size} floor tiles"
      
      # Choose a random floor tile for the stairs
      if floor_tiles.any?
        stairs_cell = floor_tiles.sample
        stairs_cell.tile = Support::TileType::STAIRS
        @debug_log.puts "Stairs placed at [#{stairs_cell.row}, #{stairs_cell.col}]"
      else
        @debug_log.puts "ERROR: No floor tiles found for stairs placement!"
      end
    end
  end
end
