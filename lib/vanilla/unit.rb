module Vanilla
  class Unit
    attr_accessor :row, :column
    attr_reader :tile

    def initialize(row:, column:, tile:)
      @row, @column = row, column
      @tile = tile
    end

    def coordinates
      [row, column]
    end
  end
end
