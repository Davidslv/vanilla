require_relative '../component'
require_relative 'transform_component'

module Vanilla
  module Components
    # Handles entity movement within the game grid.
    # This component works in conjunction with the TransformComponent to manage
    # entity position changes and collision detection.
    #
    # @example Moving an entity left
    #   movement = entity.get_component(MovementComponent)
    #   movement.move(:left)
    class MovementComponent < Component
      # Moves the entity in the specified direction
      #
      # @param direction [Symbol] The direction to move (:left, :right, :up, :down)
      # @return [Boolean] true if movement was successful, false otherwise
      def move(direction)
        transform = entity.get_component(TransformComponent)
        return false unless transform

        current_cell = transform.grid.cell_at(transform.row, transform.column)
        target_cell = get_target_cell(current_cell, direction)

        return false unless can_move?(current_cell, target_cell)

        transform.move_to(target_cell.row, target_cell.column)
      end

      private

      # Gets the target cell based on the movement direction
      #
      # @param cell [Cell] The current cell
      # @param direction [Symbol] The direction to move
      # @return [Cell, nil] The target cell or nil if no cell exists in that direction
      def get_target_cell(cell, direction)
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

      # Checks if movement between cells is possible
      #
      # @param current_cell [Cell] The cell the entity is currently in
      # @param target_cell [Cell] The cell the entity wants to move to
      # @return [Boolean] true if movement is possible, false otherwise
      def can_move?(current_cell, target_cell)
        return false unless target_cell # No cell in that direction
        return false unless current_cell.linked?(target_cell) # No passage
        true
      end
    end
  end
end 