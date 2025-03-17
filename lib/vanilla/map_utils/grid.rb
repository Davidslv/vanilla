require_relative 'cell'

module Vanilla
  module MapUtils
    class Grid
      attr_reader :rows, :columns, :cells, :monsters
      attr_accessor :distances

      def initialize(rows:, columns:)
        raise ArgumentError, "Rows must be greater than 0" if rows <= 0
        raise ArgumentError, "Columns must be greater than 0" if columns <= 0

        @rows = rows
        @columns = columns
        @cells = Array.new(rows) { |row| Array.new(columns) { |col| Cell.new(row: row, column: col) } }
        @monsters = []
        @distances = {}

        configure_cells
        set_walls
      end

      def [](row, column)
        return nil if row < 0 || row >= rows || column < 0 || column >= columns
        cells[row][column]
      end

      def cell_at(row, column)
        self[row, column]
      end

      def place(entity, row, column)
        cell = cell_at(row, column)
        return false unless cell
        cell.content = entity
        true
      end

      def clear(row, column)
        cell = cell_at(row, column)
        return false unless cell
        cell.content = nil
        true
      end

      def within_bounds?(row, column)
        row >= 0 && row < rows && column >= 0 && column < columns
      end

      def random_cell
        row = rand(rows)
        column = rand(columns)
        self[row, column]
      end

      def size
        rows * columns
      end

      def each_row(&block)
        cells.each(&block)
      end

      def each_cell
        return enum_for(:each_cell) unless block_given?
        each_row do |row|
          row.each do |cell|
            yield cell if cell
          end
        end
      end

      def dead_ends
        each_cell.select(&:dead_end?)
      end

      def contents_of(cell)
        return Vanilla::Support::TileType::FLOOR if cell.tile == Vanilla::Support::TileType::FLOOR
        
        return cell.tile if Vanilla::Support::TileType.valid?(cell.tile)
        cell.distance ? cell.distance.to_s(36) : cell.tile
      end

      def to_s
        output = ""
        each_row do |row|
          output << row.map { |cell| contents_of(cell) }.join
          output << "\n"
        end
        output
      end

      def set_walls
        each_cell do |cell|
          cell.tile = Vanilla::Support::TileType::WALL unless cell.links.any?
        end
      end

      private

      def configure_cells
        each_cell do |cell|
          row, col = cell.row, cell.column
          cell.north = self[row - 1, col]
          cell.south = self[row + 1, col]
          cell.west = self[row, col - 1]
          cell.east = self[row, col + 1]
        end
      end
    end
  end
end
