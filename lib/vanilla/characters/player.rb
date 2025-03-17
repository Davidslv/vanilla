require_relative '../entity'
require_relative '../support/tile_type'
require_relative '../components/transform_component'
require_relative '../components/movement_component'
require_relative '../components/stats_component'
require_relative '../components/combat_component'

module Vanilla
  module Characters
    class Player < Entity
      attr_accessor :name, :level, :experience, :inventory, :health, :max_health, :attack, :defense

      def initialize(name: 'player', row:, column:, grid:)
        super()
        @name = name
        @level = 1
        @experience = 0
        @inventory = []
        
        # Combat attributes
        @max_health = 50
        @health = @max_health
        @attack = 10
        @defense = 5

        # Add components
        add_component(Components::TransformComponent.new(
          self,
          grid: grid,
          row: row,
          column: column,
          tile: Support::TileType::PLAYER
        ))
        
        # Add stats component for character attributes
        stats = Components::StatsComponent.new(self)
        stats.health = @health
        stats.max_health = @max_health
        stats.attack = @attack
        stats.defense = @defense
        stats.level = @level
        stats.experience = @experience
        add_component(stats)
        
        # Add combat component for battle mechanics
        add_component(Components::CombatComponent.new(self))
        
        # Add movement component
        add_component(Components::MovementComponent.new(self))
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

      def found_stairs=(value)
        @found_stairs = value
      end

      def found_stairs?
        @found_stairs
      end
    end
  end
end