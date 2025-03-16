module Vanilla
  class Unit
    require_relative 'support/tile_type'
    attr_reader :row, :column, :tile, :grid, :health, :max_health, :attack, :defense
    attr_accessor :found_stairs

    def initialize(row:, column:, tile:, grid:)
      @row = row
      @column = column
      @tile = tile
      @grid = grid
      @max_health = 50
      @health = @max_health
      @attack = 10
      @defense = 5
      @found_stairs = false

      grid[row, column].tile = tile
    end

    def move_to(new_row, new_col)
      grid[row, column].tile = Vanilla::Support::TileType::FLOOR
      @row = new_row
      @column = new_col
      grid[row, column].tile = tile
    end

    def take_damage(amount)
      actual_damage = [amount - defense, 1].max
      @health = [health - actual_damage, 0].max
      actual_damage
    end

    def attack_target(target)
      target.take_damage(attack)
    end

    def alive?
      health > 0
    end

    def found_stairs?
      found_stairs
    end

    def gain_experience(amount)
      # To be implemented by subclasses
    end
  end
end
