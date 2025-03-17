module Vanilla
  class Map
    def initialize(rows: 10, columns: 10, algorithm:, seed: nil)
      $seed = seed || rand(999_999_999_999_999)
      srand($seed)

      @rows, @columns, @algorithm = rows, columns, algorithm
    end

    def self.create(rows:, columns:, algorithm: Vanilla::Algorithms::BinaryTree, seed:)
      new(rows: rows, columns: columns, algorithm: algorithm, seed: seed).create
    end

    def create
      grid = Vanilla::MapUtils::Grid.new(@rows, @columns)
      @algorithm.on(grid)

      # Place stairs in a random floor tile
      place_stairs(grid)

      grid
    end

    private

    def place_stairs(grid)
      # Find all floor tiles
      floor_tiles = []
      grid.each_cell do |cell|
        floor_tiles << cell if cell.tile == Support::TileType::FLOOR
      end

      # Place stairs on a random floor tile
      if floor_tiles.any?
        stairs_cell = floor_tiles.sample
        stairs_cell.tile = Support::TileType::STAIRS
      end
    end
  end
end
