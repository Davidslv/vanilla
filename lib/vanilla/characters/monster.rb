require_relative '../entity'
require_relative '../support/tile_type'
require_relative '../components/transform_component'
require_relative '../components/movement_component'

module Vanilla
  module Characters
    class Monster < Entity
      attr_reader :name, :experience_value, :health, :max_health, :attack, :defense

      def initialize(row:, column:, grid:, name: 'Monster', health: 20, attack: 5, defense: 2, experience_value: 10)
        super()
        @name = name
        @max_health = health
        @health = health
        @attack = attack
        @defense = defense
        @experience_value = experience_value

        # Add components
        add_component(Components::TransformComponent.new(self, grid, row, column, Vanilla::Support::TileType::MONSTER))
        add_component(Components::MovementComponent)
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

      def grid
        get_component(Components::TransformComponent)&.grid
      end

      def row
        get_component(Components::TransformComponent)&.row
      end

      def column
        get_component(Components::TransformComponent)&.column
      end

      def tile
        get_component(Components::TransformComponent)&.tile
      end

      def gain_experience(amount)
        # Monsters don't gain experience
      end
    end
  end
end 