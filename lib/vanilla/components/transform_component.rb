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
      # @return [Integer] The current row position in the grid
      attr_reader :row
      # @return [Integer] The current column position in the grid
      attr_reader :column
      # @return [Grid] The grid this entity exists in
      attr_reader :grid
      # @return [String] The visual representation of this entity
      attr_reader :tile

      # Creates a new transform component
      #
      # @param entity [Entity] The entity this component belongs to
      # @param grid [Grid] The game grid
      # @param row [Integer] Starting row position
      # @param column [Integer] Starting column position
      # @param tile [String, nil] The tile representation of this entity
      def initialize(entity, grid, row = 0, column = 0, tile = nil)
        super(entity)
        @grid = grid
        @row = row
        @column = column
        @tile = tile
        place_on_grid
      end

      # Moves the entity to a new position
      #
      # @param new_row [Integer] The target row position
      # @param new_column [Integer] The target column position
      # @return [Boolean] true if movement was successful, false otherwise
      def move_to(new_row, new_column)
        return false unless valid_position?(new_row, new_column)
        return false if wall_at?(new_row, new_column)
        
        # Clear old position
        clear_current_position
        
        @row = new_row
        @column = new_column
        
        # Set new position
        place_on_grid
        true
      end

      # Updates the grid reference and repositions the entity
      #
      # @param new_grid [Grid] The new grid to place the entity in
      def update_grid(new_grid)
        # Clear position in old grid
        clear_current_position if @grid
        
        # Update grid reference
        @grid = new_grid
        
        # Place entity in new grid
        place_on_grid
      end

      # Clears the entity's current position in the grid
      def clear_current_position
        return unless @grid && valid_position?(@row, @column)
        current_cell = @grid.cell_at(@row, @column)
        current_cell.content = nil
        
        # Only clear the tile if it's the entity's tile (like PLAYER)
        # Don't clear special tiles like STAIRS
        if @tile && current_cell.tile == @tile
          current_cell.tile = Vanilla::Support::TileType::FLOOR
        end
      end

      private

      # Checks if a position is within grid bounds
      #
      # @param row [Integer] The row to check
      # @param column [Integer] The column to check
      # @return [Boolean] true if position is valid, false otherwise
      def valid_position?(row, column)
        row >= 0 && row < @grid.rows && column >= 0 && column < @grid.columns
      end

      # Checks if there's a wall at the specified position
      #
      # @param row [Integer] The row to check
      # @param column [Integer] The column to check
      # @return [Boolean] true if there's a wall, false otherwise
      def wall_at?(row, column)
        @grid.cell_at(row, column).tile == Vanilla::Support::TileType::WALL
      end

      # Places the entity at its current position in the grid
      private def place_on_grid
        target_cell = @grid.cell_at(@row, @column)
        target_cell.content = entity
        target_cell.tile = @tile if @tile
      end
    end
  end
end 