module Vanilla
  module Movement
    def self.move(grid:, unit:, direction:, tile:)
      cell = grid[*unit.coordinates]
      cell.tile = Support::TileType::EMPTY

      case direction
      when :left
        self.move_left(cell, unit, tile)
      when :right
        self.move_right(cell, unit, tile)
      when :up
        self.move_up(cell, unit, tile)
      when :down
        self.move_down(cell, unit, tile)
      end
    end

    def self.move_left(cell, unit, tile)
      cell.west.tile = tile
      unit.row = cell.west.row
      unit.column = cell.west.column
    end

    def self.move_right(cell, unit, tile)
      cell.east.tile = tile
      unit.row, unit.column = cell.east.row, cell.east.column
    end

    def self.move_up(cell, unit, tile)
      cell.north.tile = tile
      unit.row, unit.column = cell.north.row, cell.north.column
    end

    def self.move_down(cell, unit, tile)
      cell.south.tile = tile
      unit.row, unit.column = cell.south.row, cell.south.column
    end
  end
end
