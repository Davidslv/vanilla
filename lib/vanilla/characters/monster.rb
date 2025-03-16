require_relative '../unit'
require_relative '../support/tile_type'

module Vanilla
  module Characters
    class Monster < Unit
      attr_reader :name, :experience_value

      def initialize(row:, column:, grid:, name: 'Monster', health: 20, attack: 5, defense: 2, experience_value: 10)
        super(row: row, column: column, tile: Vanilla::Support::TileType::MONSTER, grid: grid)
        @name = name
        @max_health = health
        @health = health
        @attack = attack
        @defense = defense
        @experience_value = experience_value
      end

      def alive?
        @health > 0
      end

      def take_damage(amount)
        actual_damage = [amount - defense, 1].max
        @health = [health - actual_damage, 0].max
        actual_damage
      end

      def attack_target(target)
        target.take_damage(@attack)
      end

      def gain_experience(amount)
        # Monsters don't gain experience
      end
    end
  end
end 