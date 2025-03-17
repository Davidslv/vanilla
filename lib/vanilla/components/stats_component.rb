require_relative '../component'

module Vanilla
  module Components
    # Manages an entity's game statistics and attributes.
    # This component handles character stats like health, experience, level,
    # attack, and defense. It provides methods for combat calculations and
    # character progression.
    #
    # @example Creating stats for a player
    #   stats = StatsComponent.new(player, health: 50, attack: 10)
    class StatsComponent < Component
      attr_accessor :health, :max_health, :attack, :defense, :level, :experience

      # Creates a new stats component
      #
      # @param entity [Entity] The entity this component belongs to
      def initialize(entity)
        super
        @health = 0
        @max_health = 0
        @attack = 0
        @defense = 0
        @level = 1
        @experience = 0
      end

      # Checks if the entity is still alive
      #
      # @return [Boolean] true if health is above 0, false otherwise
      def alive?
        @health > 0
      end

      # Applies damage to the entity, considering defense
      #
      # @param amount [Integer] The amount of damage to apply
      # @return [Integer] The actual amount of damage dealt
      def take_damage(amount)
        actual_damage = [amount - @defense, 1].max
        @health = [@health - actual_damage, 0].max
        actual_damage
      end

      # Adds experience points and handles level up if necessary
      #
      # @param amount [Integer] The amount of experience to gain
      def gain_experience(amount)
        @experience += amount
        while @experience >= experience_to_next_level
          level_up
        end
      end

      # Calculates the experience needed for the next level
      #
      # @return [Integer] Experience points needed for next level
      def experience_to_next_level
        100 * @level
      end

      private

      # Handles the level up process, increasing stats
      def level_up
        @level += 1
        @max_health += 10
        @health = @max_health
        @attack += 2
        @defense += 1
        @experience = 0
      end
    end
  end
end 