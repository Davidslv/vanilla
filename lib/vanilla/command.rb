module Vanilla
  class Command
    def initialize(key:, grid:, unit:)
      @key = key
      @grid, @unit = grid, unit
    end

    def self.process(key:, grid:, unit:)
      new(key: key, grid: grid, unit: unit).process
    end

    def process
      case key
      when "k", :KEY_UP
        Vanilla::Draw.movement(grid: grid, unit: unit, direction: :up)
      when "j", :KEY_DOWN
        Vanilla::Draw.movement(grid: grid, unit: unit, direction: :down)
      when "l", :KEY_RIGHT
        Vanilla::Draw.movement(grid: grid, unit: unit, direction: :right)
      when "h", :KEY_LEFT
        Vanilla::Draw.movement(grid: grid, unit: unit, direction: :left)
      when "\C-c", "q"
        exit
      end
    end

    private

    attr_reader :key, :grid, :unit
  end
end
