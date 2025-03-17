require_relative '../entity'
require_relative '../support/tile_type'
require_relative '../components/transform_component'
require_relative '../components/movement_component'
require_relative '../components/stats_component'
require_relative '../components/combat_component'

module Vanilla
  module Characters
    # Represents a monster in the game
    class Monster < Entity
      attr_reader :name, :experience_value, :health, :max_health, :attack, :defense

      # Initialize a new monster
      #
      # @param grid [MapUtils::Grid] The game grid
      # @param row [Integer] Starting row position
      # @param col [Integer] Starting column position
      # @param options [Hash] Monster options
      # @option options [Integer] :health Starting health (default: 50)
      # @option options [Integer] :attack Attack power (default: 5)
      # @option options [Integer] :defense Defense power (default: 2)
      # @option options [Integer] :experience Experience awarded (default: 10)
      def initialize(grid:, row:, col:, **options)
        super()
        
        # Initialize transform component
        transform = Components::TransformComponent.new(grid, [row, col])
        add_component(transform)
        
        add_component(Components::StatsComponent.new(
          self,
          health: options[:health] || 50,
          max_health: options[:health] || 50,
          attack: options[:attack] || 5,
          defense: options[:defense] || 2,
          level: 1,
          experience: 0
        ))

        add_component(Components::CombatComponent.new(self))
        @experience_value = options[:experience] || 10
        
        # Add movement component
        add_component(Components::MovementComponent.new(self))
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

      # Check if monster is alive
      #
      # @return [Boolean] true if alive
      def alive?
        stats = get_component(Components::StatsComponent)
        stats.alive?
      end

      # Get experience value when defeated
      #
      # @return [Integer] Experience points awarded
      def experience_value
        @experience_value
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
        # Monsters don't gain experience
      end
    end
  end
end 