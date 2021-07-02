module Vanilla
  module Draw
    def self.map(grid)
      system("clear")
      puts "Seed: #{$seed}"

      puts Vanilla::Output::Terminal.new(grid)
    end

    def self.tile(grid:, row:, column:, tile:)
      cell = grid[row, column]
      cell.tile = tile

      self.map(grid)
    end

    def self.player(grid:, row:, column:)
      self.tile(grid: grid, row: row, column: column, tile: Vanilla::Support::TileType::PLAYER)
    end

    def self.stairs(grid:, row:, column:)
      self.tile(grid: grid, row: row, column: column, tile: Vanilla::Support::TileType::STAIRS)
    end

    def self.movement(grid:, coordinates:, direction:, tile: Support::TileType::PLAYER)
      Vanilla::Movement.move(grid: grid, coordinates: coordinates, direction: direction, tile: tile)

      self.map(grid)
    end
  end
end