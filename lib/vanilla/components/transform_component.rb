require_relative 'base_component'
require_relative '../support/tile_type'

module Vanilla
  module Components
    # Manages an entity's position and representation in the game grid.
    # This component handles the entity's location, movement, and visual representation
    # through its tile type. It ensures proper grid state management when entities move
    # or change position.
    #
    # @example Creating a transform component for a player
    #   transform = TransformComponent.new(grid, [0, 0])
    class TransformComponent < BaseComponent
      include Support::TileType

      attr_reader :grid, :position

      # Creates a new transform component
      #
      # @param grid [MapUtils::Grid] The game grid
      # @param position [Array<Integer>] Initial [row, col] position
      def initialize(grid, position)
        super()
        @grid = grid
        @position = position
        place_on_grid if @grid
      end

      # Updates the grid reference and places entity on new grid
      #
      # @param new_grid [Grid] The new grid to place the entity on
      def update_grid(new_grid)
        # Clear the current position in the old grid
        if @grid
          current_cell = @grid.get(@position[0], @position[1])
          current_cell.tile = Support::TileType::FLOOR
        end
        
        # Update to the new grid
        @grid = new_grid
        
        # Place the entity in the new grid
        if @grid
          target_cell = @grid.get(@position[0], @position[1])
          target_cell.tile = Support::TileType::PLAYER
        end
      end

      # Moves the entity to a new position
      #
      # @param row [Integer] Target row
      # @param col [Integer] Target column
      # @return [Boolean] true if move successful
      def move_to(row, col)
        return false unless valid_position?(row, col)
        
        target_cell = @grid.get(row, col)
        return false if target_cell.tile == Support::TileType::WALL
        
        # Store the original tile type
        original_tile = target_cell.tile
        
        # Update the grid
        current_cell = @grid.get(@position[0], @position[1])
        current_cell.tile = Support::TileType::FLOOR
        
        # Update position
        @position = [row, col]
        
        # Update target cell
        target_cell = @grid.get(@position[0], @position[1])
        
        # If the target was stairs, preserve that information
        if original_tile == Support::TileType::STAIRS
          target_cell.tile = Support::TileType::STAIRS
        else
          target_cell.tile = Support::TileType::PLAYER
        end
        
        true
      end

      # Gets the current position
      #
      # @return [Array<Integer>] The current [row, column] position
      def position
        @position
      end

      # Get current row
      #
      # @return [Integer] Current row
      def row
        @position[0]
      end

      # Get current column
      #
      # @return [Integer] Current column
      def column
        @position[1]
      end

      def current_cell
        return nil unless @grid
        @grid.get(@position[0], @position[1])
      end

      # Check if a position is valid within the grid
      #
      # @param row [Integer] The row position to check
      # @param col [Integer] The column position to check
      # @return [Boolean] true if the position is valid
      def valid_position?(row, col)
        return false unless @grid
        row >= 0 && row < @grid.rows && col >= 0 && col < @grid.cols
      end

      private

      def valid_move?(row, col)
        return false unless valid_position?(row, col)
        
        target_cell = @grid.get(row, col)
        target_cell.tile == Support::TileType::FLOOR || target_cell.tile == Support::TileType::STAIRS
      end

      # Places the entity on the grid at its current position
      def place_on_grid
        target_cell = @grid.get(@position[0], @position[1])
        target_cell.tile = Support::TileType::PLAYER
      end

      # Clears the entity's current position on the grid
      def clear_current_position
        return unless @grid
        current_cell = @grid.get(@position[0], @position[1])
        if current_cell.content == entity
          current_cell.content = nil
          current_cell.tile = Support::TileType::FLOOR
        end
      end

      def remove_from_grid
        current_cell = @grid.get(@position[0], @position[1])
        current_cell.tile = Support::TileType::FLOOR
      end
    end
  end
end 