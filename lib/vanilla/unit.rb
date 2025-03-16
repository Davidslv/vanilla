module Vanilla
  class Unit
    attr_accessor :row, :column, :grid
    attr_reader :tile
    attr_accessor :found_stairs

    alias found_stairs? found_stairs

    def initialize(row:, column:, tile:, grid:, found_stairs: false)
      @row, @column = row, column
      @tile = tile
      @grid = grid
      @found_stairs = false
    end

    def coordinates
      [row, column]
    end
  end
end
