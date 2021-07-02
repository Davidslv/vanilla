module Vanilla
  module Movement
    def self.move(grid:, coordinates:, direction:, tile:)
      cell = grid[*coordinates]
      cell.tile = Support::TileType::EMPTY

      case direction
      when :left
        self.move_left(cell, tile)
      when :right
        self.move_right(cell, tile)
      when :up
        self.move_up(cell, tile)
      when :down
        self.move_down(cell, tile)
      end
    end

    def self.move_left(cell, tile)
      cell.west.tile = tile
      $current_position = [cell.west.row, cell.west.column]
    end

    def self.move_right(cell, tile)
      cell.east.tile = tile
      $current_position = [cell.east.row, cell.east.column]
    end

    def self.move_up(cell, tile)
      cell.north.tile = tile
      $current_position = [cell.north.row, cell.north.column]
    end

    def self.move_down(cell, tile)
      cell.south.tile = tile
      $current_position = [cell.south.row, cell.south.column]
    end
  end
end
