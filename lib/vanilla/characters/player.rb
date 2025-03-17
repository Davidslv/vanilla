require_relative '../unit'
require_relative '../support/tile_type'

module Vanilla
  module Characters
    class Player < Unit
      attr_accessor :name, :level, :experience, :inventory, :health, :max_health, :attack, :defense

      def initialize(name: 'player', row:, column:, grid:)
        super(row: row, column: column, tile: Vanilla::Support::TileType::PLAYER, grid: grid)
        @name = name
        
        @level = 1
        @experience = 0
        @inventory = []
        
        # Combat attributes
        @max_health = 50
        @health = @max_health
        @attack = 10
        @defense = 5
      end

      def gain_experience(amount)
        @experience += amount
        while @experience >= experience_to_next_level
          level_up
        end
      end

      def level_up
        @level += 1
        @max_health += 10
        @health = @max_health
        @attack += 2
        @defense += 1
        @experience = 0
      end

      def alive?
        @health > 0
      end

      def take_damage(amount)
        actual_damage = [amount - @defense, 1].max
        @health = [@health - actual_damage, 0].max
        actual_damage
      end

      def attack_target(target)
        target.take_damage(@attack)
      end

      def add_to_inventory(item)
        @inventory << item
      end

      def remove_from_inventory(item)
        @inventory.delete(item)
      end

      def experience_to_next_level
        100
      end
    end
  end
end