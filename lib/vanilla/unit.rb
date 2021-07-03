module Vanilla
  class Unit
    attr_accessor :row, :column
    attr_reader :tile
    attr_accessor :found_stairs

    alias found_stairs? found_stairs

    def initialize(row:, column:, tile:, found_stairs: false)
      @row, @column = row, column
      @tile = tile
      @found_stairs = false
    end

    def coordinates
      [row, column]
    end
  end
end
