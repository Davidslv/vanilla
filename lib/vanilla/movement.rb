module Vanilla
  module Movement
    def self.move(grid:, unit:, direction:)
      cell = grid[*unit.coordinates]
      cell.tile = Support::TileType::EMPTY

      case direction
      when :left
        self.move_left(cell, unit)
      when :right
        self.move_right(cell, unit)
      when :up
        self.move_up(cell, unit)
      when :down
        self.move_down(cell, unit)
      end
    end

    def self.move_left(cell, unit)
      cell.west.tile = unit.tile
      unit.row, unit.column = cell.west.row, cell.west.column
    end

    def self.move_right(cell, unit)
      cell.east.tile = unit.tile
      unit.row, unit.column = cell.east.row, cell.east.column
    end

    def self.move_up(cell, unit)
      cell.north.tile = unit.tile
      unit.row, unit.column = cell.north.row, cell.north.column
    end

    def self.move_down(cell, unit)
      cell.south.tile = unit.tile
      unit.row, unit.column = cell.south.row, cell.south.column
    end
  end
end
