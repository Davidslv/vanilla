require_relative '../entity'
require_relative '../components/transform_component'
require_relative '../components/combat_component'
require_relative '../components/stats_component'
require_relative '../support/tile_type'

module Vanilla
  module Characters
    class Player < Entity
      include Support::TileType

      attr_accessor :name, :level, :experience, :inventory, :health, :max_health, :attack, :defense

      def initialize(grid:, row:, col:)
        super()
        
        add_component(Components::TransformComponent.new(
          self, grid, row, col, tile: PLAYER
        ))
        
        add_component(Components::CombatComponent.new(
          self, strength: 10
        ))
        
        add_component(Components::StatsComponent.new(
          self, hp: 100, max_hp: 100, level: 1
        ))
      end

      def transform
        get_component(Components::TransformComponent)
      end

      def combat
        get_component(Components::CombatComponent)
      end

      def stats
        get_component(Components::StatsComponent)
      end

      def position
        transform&.position
      end

      def current_cell
        transform&.current_cell
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
        transform&.grid
      end

      def row
        transform&.row
      end

      def column
        transform&.column
      end

      def tile
        transform&.tile
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