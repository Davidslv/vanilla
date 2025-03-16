module Vanilla
  module Movement
    def self.move(grid:, unit:, direction:)
      cell = grid[*unit.coordinates]

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
      return unless cell.linked?(cell.west)

      unit.found_stairs = cell.west.stairs?

      cell.tile = Vanilla::Support::TileType::EMPTY
      cell.west.tile = unit.tile
      unit.row, unit.column = cell.west.row, cell.west.column
    end

    def self.move_right(cell, unit)
      return unless cell.linked?(cell.east)

      unit.found_stairs = cell.east.stairs?

      cell.tile = Vanilla::Support::TileType::EMPTY
      cell.east.tile = unit.tile
      unit.row, unit.column = cell.east.row, cell.east.column
    end

    def self.move_up(cell, unit)
      return unless cell.linked?(cell.north)

      unit.found_stairs = cell.north.stairs?

      cell.tile = Vanilla::Support::TileType::EMPTY
      cell.north.tile = unit.tile
      unit.row, unit.column = cell.north.row, cell.north.column
    end

    def self.move_down(cell, unit)
      return unless cell.linked?(cell.south)

      unit.found_stairs = cell.south.stairs?

      cell.tile = Vanilla::Support::TileType::EMPTY
      cell.south.tile = unit.tile
      unit.row, unit.column = cell.south.row, cell.south.column
    end
  end
end
