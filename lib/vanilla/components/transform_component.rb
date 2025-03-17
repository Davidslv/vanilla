require_relative '../component'
require_relative '../support/tile_type'

module Vanilla
  module Components
    # Manages an entity's position and representation in the game grid.
    # This component handles the entity's location, movement, and visual representation
    # through its tile type. It ensures proper grid state management when entities move
    # or change position.
    #
    # @example Creating a transform component for a player
    #   transform = TransformComponent.new(player, grid, 0, 0, TileType::PLAYER)
    class TransformComponent < Component
      include Support::TileType

      attr_reader :row, :column, :grid, :tile

      # Creates a new transform component
      #
      # @param entity [Entity] The entity this component belongs to
      # @param grid [Grid] The game grid
      # @param row [Integer] Starting row position
      # @param column [Integer] Starting column position
      # @param tile [String] The tile representation (default: FLOOR)
      def initialize(entity, grid:, row:, column:, tile: FLOOR)
        super(entity)
        @grid = grid
        @row = row
        @column = column
        @tile = tile
        place_on_grid
      end

      # Updates the grid reference and places entity on new grid
      #
      # @param new_grid [Grid] The new grid to place the entity on
      def update_grid(new_grid)
        clear_current_position
        @grid = new_grid
        place_on_grid
      end

      # Moves the entity to a new position
      #
      # @param new_row [Integer] The target row
      # @param new_col [Integer] The target column
      # @return [Boolean] true if move was successful, false otherwise
      def move_to(new_row, new_col)
        return false unless valid_move?(new_row, new_col)

        clear_current_position
        @row = new_row
        @column = new_col
        place_on_grid
        true
      end

      # Gets the current position
      #
      # @return [Array<Integer>] The current [row, column] position
      def position
        [@row, @column]
      end

      private

      # Places the entity on the grid at its current position
      def place_on_grid
        target_cell = @grid.cell_at(@row, @column)
        target_cell.content = entity
        target_cell.tile = @tile
      end

      # Clears the entity's current position on the grid
      def clear_current_position
        return unless @grid
        current_cell = @grid.cell_at(@row, @column)
        if current_cell.content == entity
          current_cell.content = nil
          current_cell.tile = FLOOR
        end
      end

      # Checks if a move to the target position is valid
      #
      # @param new_row [Integer] The target row
      # @param new_col [Integer] The target column
      # @return [Boolean] true if move is valid, false otherwise
      def valid_move?(new_row, new_col)
        return false unless @grid
        return false if new_row < 0 || new_col < 0
        return false if new_row >= @grid.rows || new_col >= @grid.columns
        true
      end
    end
  end
end 