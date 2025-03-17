module Vanilla
  module Draw
    require_relative 'support/tile_type'
    require_relative 'output/terminal'

    def self.map(grid, options = {})
      output = "+" + "---+" * grid.cols + "\n"

      grid.each_row do |row|
        top = "|"
        bottom = "+"

        row.each do |cell|
          next unless cell

          # Get cell content
          content = cell.to_s
          content = " #{content} " if content.length == 1
          content = " #{content}" if content.length == 2

          # Get boundaries based on neighboring cells
          east_boundary = east_boundary_for(cell)
          south_boundary = south_boundary_for(cell)
          corner = "+"

          top << content << east_boundary
          bottom << south_boundary << corner
        end

        output << top << "\n"
        output << bottom << "\n"
      end

      puts output
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
      grid.set(row, column, tile)
    end

    def self.clear_screen(*)
      print "\e[2J\e[H"
    end

    def self.display(terminal:)
      terminal.write
    end

    private

    def self.east_boundary_for(cell)
      return "|" unless cell.tile == Support::TileType::FLOOR || cell.tile == Support::TileType::STAIRS
      east_neighbor = cell.east
      return "|" unless east_neighbor && (east_neighbor.tile == Support::TileType::FLOOR || east_neighbor.tile == Support::TileType::STAIRS)
      " "
    end

    def self.south_boundary_for(cell)
      return "---" unless cell.tile == Support::TileType::FLOOR || cell.tile == Support::TileType::STAIRS
      south_neighbor = cell.south
      return "---" unless south_neighbor && (south_neighbor.tile == Support::TileType::FLOOR || south_neighbor.tile == Support::TileType::STAIRS)
      "   "
    end
  end
end
