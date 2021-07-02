module Vanilla
  class Unit
    attr_accessor :row, :column

    def initialize(row:, column:)
      @row, @column = row, column
    end

    def coordinates
      [row, column]
    end
  end
end
