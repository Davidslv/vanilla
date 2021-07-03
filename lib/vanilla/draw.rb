module Vanilla
  module Draw
    def self.map(grid)
      Curses.clear
      Curses.refresh

      puts "Seed: #{$seed}"

      puts Vanilla::Output::Terminal.new(grid)
    end

    def self.tile(grid:, row:, column:, tile:)
      cell = grid[row, column]
      cell.tile = tile

      self.map(grid)
    end

    def self.player(grid:, unit:)
      self.tile(grid: grid, row: unit.row, column: unit.column, tile: unit.tile)
    end

    def self.stairs(grid:, row:, column:)
      self.tile(grid: grid, row: row, column: column, tile: Vanilla::Support::TileType::STAIRS)
    end

    def self.movement(grid:, unit:, direction:)
      Vanilla::Movement.move(grid: grid, unit: unit, direction: direction)

      self.map(grid)
    end
  end
end
