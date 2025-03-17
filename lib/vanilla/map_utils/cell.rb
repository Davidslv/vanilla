module Vanilla
  module MapUtils
    # Represents a single cell in the game grid
    class Cell
      attr_reader :row, :col, :tile
      attr_accessor :content, :north, :south, :east, :west

      # Initialize a new cell
      #
      # @param row [Integer] The row position of the cell
      # @param col [Integer] The column position of the cell
      # @param tile [TileType] The type of tile in this cell
      def initialize(row:, col:, tile: Support::TileType::FLOOR)
        @row = row
        @col = col
        @tile = tile
        @content = nil
        @links = {}
        @north = nil
        @south = nil
        @east = nil
        @west = nil
      end

      # Set the tile type for this cell
      #
      # @param type [TileType] The new tile type
      def tile=(type)
        @tile = type
      end

      # Get the position of the cell as an array
      #
      # @return [Array<Integer>] An array containing the row and column
      def position
        [row, col]
      end

      # Check if this cell contains a monster
      #
      # @return [Boolean] true if the cell contains a monster
      def monster?
        @content&.is_a?(Characters::Monster)
      end

      # Check if this cell has a special tile type
      #
      # @return [Boolean] true if the cell has a special tile type
      def special?
        @tile != Support::TileType::FLOOR
      end

      # Check if the cell is walkable
      #
      # @return [Boolean] true if the cell can be walked on
      def walkable?
        @tile != Support::TileType::WALL && @content.nil?
      end

      # Convert the cell to a string representation
      #
      # @return [String] The string representation of the cell
      def to_s
        @tile.to_s
      end

      # Link this cell to another cell
      #
      # @param cell [Cell] The cell to link to
      # @param bidirectional [Boolean] Whether to link both ways
      def link(cell:, bidirectional: true)
        @links[cell] = true
        cell.link(cell: self, bidirectional: false) if bidirectional
      end

      # Unlink this cell from another cell
      #
      # @param cell [Cell] The cell to unlink from
      # @param bidirectional [Boolean] Whether to unlink both ways
      def unlink(cell:, bidirectional: true)
        @links.delete(cell)
        cell.unlink(cell: self, bidirectional: false) if bidirectional
      end

      # Check if this cell is linked to another cell
      #
      # @param cell [Cell] The cell to check
      # @return [Boolean] true if the cells are linked
      def linked?(cell)
        @links.key?(cell)
      end

      # Get all cells linked to this cell
      #
      # @return [Array<Cell>] Array of linked cells
      def links
        @links.keys
      end

      # Get all neighboring cells
      #
      # @return [Array<Cell>] Array of neighboring cells
      def neighbors
        list = []
        list << north if north
        list << south if south
        list << east if east
        list << west if west
        list
      end
    end
  end
end