module Vanilla
  module Characters
    class Monster < Unit
      attr_accessor :name, :health, :max_health, :attack, :defense, :experience_value

      def initialize(name: 'monster', row:, column:, grid:, health: 20, attack: 5, defense: 2, experience_value: 10)
        super(row: row, column: column, tile: Support::TileType::MONSTER, grid: grid)
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
        actual_damage = [amount - @defense, 1].max
        @health -= actual_damage
        actual_damage
      end

      def attack_target(target)
        target.take_damage(@attack)
      end
    end
  end
end 