require_relative 'cell'

module Vanilla
  module MapUtils
    # Represents the game map grid
    class Grid
      attr_reader :rows, :cols

      # Initialize a new grid
      #
      # @param rows [Integer] Number of rows in the grid
      # @param cols [Integer] Number of columns in the grid
      def initialize(rows:, cols:)
        @rows = rows
        @cols = cols
        @grid = Array.new(rows) do |row|
          Array.new(cols) do |col|
            Cell.new(row: row, col: col)
          end
        end
        configure_cells
      end

      # Get the cell at the specified position
      #
      # @param row [Integer] The row position
      # @param col [Integer] The column position
      # @return [Cell, nil] The cell at the position, or nil if out of bounds
      def cell_at(row, col)
        return nil unless valid_position?(row, col)
        @grid[row][col]
      end

      # Set the tile type at the specified position
      #
      # @param row [Integer] The row position
      # @param col [Integer] The column position
      # @param tile [TileType] The tile type to set
      # @return [Boolean] true if the tile was set successfully
      def set(row, col, tile)
        return false unless valid_position?(row, col)
        @grid[row][col].tile = tile
        true
      end

      # Check if a position is valid within the grid
      #
      # @param row [Integer] The row position to check
      # @param col [Integer] The column position to check
      # @return [Boolean] true if the position is valid
      def valid_position?(row, col)
        row >= 0 && row < @rows && col >= 0 && col < @cols
      end

      # Iterate over each row in the grid
      #
      # @yield [Array<Cell>] Each row of cells
      def each_row(&block)
        @grid.each(&block)
      end

      # Iterate over each cell in the grid
      #
      # @yield [Cell] Each cell in the grid
      def each_cell(&block)
        @grid.each do |row|
          row.each(&block)
        end
      end

      # Convert the grid to a string representation
      #
      # @return [String] The string representation of the grid
      def to_s
        output = ""
        each_row do |row|
          output << row.map(&:to_s).join
          output << "\n"
        end
        output
      end

      # Set walls for unlinked cells
      def set_walls
        each_cell do |cell|
          if cell.links.empty?
            cell.tile = Support::TileType::WALL
          end
        end
      end

      private

      # Configure cell neighbors
      def configure_cells
        each_cell do |cell|
          row, col = cell.row, cell.col

          cell.north = cell_at(row - 1, col)
          cell.south = cell_at(row + 1, col)
          cell.west = cell_at(row, col - 1)
          cell.east = cell_at(row, col + 1)
        end
      end
    end
  end
end
