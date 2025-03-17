module Vanilla
  module Draw
    require_relative 'support/tile_type'
    require_relative 'output/terminal'

    def self.map(grid, options = {})
      Output::Terminal.draw(grid)
    end

    def self.place_player(grid:, player:)
      tile(grid: grid, row: player.row, column: player.column, tile: Vanilla::Support::TileType::PLAYER)
    end

    def self.place_monster(grid:, monster:)
      tile(grid: grid, row: monster.row, column: monster.column, tile: Vanilla::Support::TileType::MONSTER)
    end

    def self.stairs(grid:, row:, column:)
      tile(grid: grid, row: row, column: column, tile: Vanilla::Support::TileType::STAIRS)
    end

    def self.tile(grid:, row:, column:, tile:)
      raise ArgumentError, 'Invalid tile type' unless Vanilla::Support::TileType.valid?(tile)
      grid[row, column].tile = tile
    end

    def self.clear_screen(*)
      print "\e[2J\e[H"
    end

    def self.display(terminal:)
      terminal.write
    end
  end
end
