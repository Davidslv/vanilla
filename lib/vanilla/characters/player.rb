require_relative 'shared/movement'

module Vanilla
  module Characters
    class Player < Unit
      include Vanilla::Characters::Shared::Movement

      attr_accessor :name, :level, :experience, :inventory, :health, :max_health, :attack, :defense

      def initialize(name: 'player', row:, column:, grid:)
        super(row: row, column: column, tile: Support::TileType::PLAYER, grid: grid)
        @name = name
        
        @level = 1
        @experience = 0
        @inventory = []
        
        # Combat attributes
        @max_health = 50
        @health = @max_health
        @attack = 8
        @defense = 3
      end

      def gain_experience(amount)
        @experience += amount
        level_up if @experience >= experience_to_next_level
      end

      def level_up
        @level += 1
        @experience -= experience_to_next_level
        # Level up bonuses
        @max_health += 5
        @health = @max_health
        @attack += 2
        @defense += 1
      end

      def alive?
        @health > 0
      end

      def take_damage(amount)
        actual_damage = [amount - @defense, 1].max
        @health -= actual_damage
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
        @level * 100 # Simple formula, can be adjusted
      end

      private
    end
  end
end