require_relative 'cell'

module Vanilla
  class Grid
    attr_reader :rows, :columns

    def initialize(rows:, columns:)
      @rows, @columns = rows, columns

      @grid = prepare_grid

      configure_cells
    end

    def prepare_grid
      Array.new(rows) do |row|
        Array.new(columns) do |column|
          Cell.new(row: row, column: column)
        end
      end
    end

    def configure_cells
      each_cell do |cell|
        row, col = cell.row, cell.column

        cell.north = self[row - 1, col]
        cell.south = self[row + 1, col]
        cell.west  = self[row, col - 1]
        cell.east  = self[row, col + 1]
      end
    end

    # custom array accessor
    # primarily for granting random access to arbitrary cells in the grid
    # but also do bounds checking, so when a coordinate is passed that
    # is out of bounds, it returns nil.
    def [](row, column)
      return nil unless row.between?(0, @rows - 1)
      return nil unless column.between?(0, @grid[row].count - 1)

      @grid[row][column]
    end

    def random_cell
      row = rand(@rows)
      column = rand(@grid[row].count)

      self[row, column]
    end

    def size
      @rows * @columns
    end

    def contents_of(cell)
      " "
    end

    # iterator to loop over cells on the grid
    # some algorithms want to look at cells a row at a time (Sidewinder)
    # others just want to look at cells (Binary Tree)
    def each_row
      @grid.each do |row|
        yield row
      end
    end

    def each_cell
      each_row do |row|
        row.each do |cell|
          yield cell if cell
        end
      end
    end
  end
end
