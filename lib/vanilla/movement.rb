module Vanilla
  module Movement
    require_relative 'support/tile_type'

    def self.move(grid:, unit:, direction:)
      current_cell = grid[unit.row, unit.column]
      target_cell = get_target_cell(current_cell, direction)

      return false unless can_move?(current_cell, target_cell)

      # Perform the move
      unit.found_stairs = target_cell.stairs?
      unit.move_to(target_cell.row, target_cell.column)
      true
    end

    private

    def self.get_target_cell(cell, direction)
      case direction
      when :left
        cell.west
      when :right
        cell.east
      when :up
        cell.north
      when :down
        cell.south
      end
    end

    def self.can_move?(current_cell, target_cell)
      return false unless target_cell # No cell in that direction
      return false unless current_cell.linked?(target_cell) # No passage
      true
    end
  end
end
