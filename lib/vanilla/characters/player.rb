require_relative '../entity'
require_relative '../components/transform_component'
require_relative '../components/combat_component'
require_relative '../components/stats_component'
require_relative '../components/movement_component'
require_relative '../support/tile_type'

module Vanilla
  module Characters
    # Represents a player character in the game
    class Player < Entity
      include Support::TileType

      attr_accessor :name, :level, :experience, :inventory, :health, :max_health, :attack, :defense

      # Initialize a new player
      #
      # @param grid [MapUtils::Grid] The game grid
      # @param row [Integer] Starting row position
      # @param col [Integer] Starting column position
      def initialize(grid:, row:, col:)
        super()
        
        # Initialize transform component
        transform = Components::TransformComponent.new(self, grid, row, col)
        add_component(transform)
        
        add_component(Components::StatsComponent.new(
          self,
          health: 100,
          max_health: 100,
          attack: 10,
          defense: 5,
          level: 1,
          experience: 0
        ))

        add_component(Components::MovementComponent.new(self))
        add_component(Components::CombatComponent.new(self))
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

      # Take damage and return amount taken
      #
      # @param amount [Integer] Amount of damage to take
      # @return [Integer] Actual damage taken
      def take_damage(amount)
        stats = get_component(Components::StatsComponent)
        stats.take_damage(amount)
      end

      # Attack a target
      #
      # @param target [Entity] Target to attack
      # @return [Integer] Damage dealt
      def attack(target)
        combat = get_component(Components::CombatComponent)
        return 0 unless combat
        combat.attack(target)
      end

      # Gain experience points
      #
      # @param amount [Integer] Amount of experience to gain
      # @return [Boolean] true if leveled up
      def gain_experience(amount)
        stats = get_component(Components::StatsComponent)
        stats.gain_experience(amount)
      end

      # Check if player is alive
      #
      # @return [Boolean] true if alive
      def alive?
        stats = get_component(Components::StatsComponent)
        stats.alive?
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