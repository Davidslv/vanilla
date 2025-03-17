require_relative '../entity'
require_relative '../support/tile_type'
require_relative '../components/transform_component'
require_relative '../components/movement_component'
require_relative '../components/stats_component'
require_relative '../components/combat_component'

module Vanilla
  module Characters
    class Monster < Entity
      attr_reader :name, :experience_value, :health, :max_health, :attack, :defense

      def initialize(grid:, row:, column:, level: 1)
        super()
        
        # Add transform component for position
        add_component(Components::TransformComponent.new(
          self,
          grid: grid,
          row: row,
          column: column,
          tile: Support::TileType::MONSTER
        ))
        
        # Add stats component with level-scaled attributes
        stats = Components::StatsComponent.new(self)
        stats.health = 20 + (level * 5)      # Base 20 HP, +5 per level
        stats.max_health = stats.health
        stats.attack = 5 + (level * 2)       # Base 5 attack, +2 per level
        stats.defense = 2 + level            # Base 2 defense, +1 per level
        stats.level = level
        stats.experience = 0
        add_component(stats)
        
        # Add combat component for battle mechanics
        add_component(Components::CombatComponent.new(self))
        
        # Add movement component
        add_component(Components::MovementComponent.new(self))
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