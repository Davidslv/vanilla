require_relative 'base_component'
require_relative 'transform_component'

module Vanilla
  module Components
    # Handles entity movement and position updates
    class MovementComponent < BaseComponent
      # Initialize a new movement component
      #
      # @param entity [Entity] The entity this component belongs to
      def initialize(entity)
        super()
        @entity = entity
      end

      # Move the entity in a direction
      #
      # @param row_delta [Integer] Row direction (-1, 0, 1)
      # @param col_delta [Integer] Column direction (-1, 0, 1)
      # @return [Boolean] true if movement was successful
      def move(row_delta, col_delta)
        transform = entity.get_component(TransformComponent)
        return false unless transform

        new_row = transform.row + row_delta
        new_col = transform.col + col_delta

        transform.move_to(new_row, new_col)
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