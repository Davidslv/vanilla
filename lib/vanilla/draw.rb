module Vanilla
  module Draw
    require_relative 'support/tile_type'

    def self.map(grid, options = {})
      Output::Terminal.draw(grid)
    end

    def self.player(grid:, unit:)
      tile(grid: grid, row: unit.row, column: unit.column, tile: Vanilla::Support::TileType::PLAYER)
    end

    def self.monster(grid:, unit:)
      tile(grid: grid, row: unit.row, column: unit.column, tile: Vanilla::Support::TileType::MONSTER)
    end

    def self.stairs(grid:, row:, column:)
      tile(grid: grid, row: row, column: column, tile: Vanilla::Support::TileType::STAIRS)
    end

    def self.tile(grid:, row:, column:, tile:)
      raise ArgumentError, 'Invalid tile type' unless Vanilla::Support::TileType.valid?(tile)
      grid[row, column].tile = tile
    end

    def self.clear_screen
      Output::Terminal.clear
    end

    def self.display(terminal:)
      terminal.write
    end
  end
end
