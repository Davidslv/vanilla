require_relative 'base_component'

module Vanilla
  module Components
    class TransformComponent < BaseComponent
      attr_accessor :row, :column, :grid

      def initialize(entity, grid, row = 0, column = 0)
        super(entity)
        @grid = grid
        @row = row
        @column = column
        place_on_grid
      end

      def move_to(new_row, new_column)
        return false unless valid_position?(new_row, new_column)
        
        @grid.clear(@row, @column)
        @row = new_row
        @column = new_column
        place_on_grid
        true
      end

      private

      def valid_position?(row, column)
        @grid.within_bounds?(row, column) && @grid.cell_at(row, column).walkable?
      end

      def place_on_grid
        @grid.place(entity, @row, @column)
      end
    end
  end
end 