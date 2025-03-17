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
      # @return [Integer] Current health points
      attr_reader :health
      # @return [Integer] Maximum health points
      attr_reader :max_health
      # @return [Integer] Attack power
      attr_reader :attack
      # @return [Integer] Defense rating
      attr_reader :defense
      # @return [Integer] Current experience points
      attr_reader :experience
      # @return [Integer] Current level
      attr_reader :level

      # Creates a new stats component
      #
      # @param entity [Entity] The entity this component belongs to
      # @param health [Integer] Starting health points
      # @param attack [Integer] Starting attack power
      # @param defense [Integer] Starting defense rating
      # @param level [Integer] Starting level
      # @param experience [Integer] Starting experience points
      def initialize(entity, health: 50, attack: 10, defense: 5, level: 1, experience: 0)
        super(entity)
        @max_health = health
        @health = @max_health
        @attack = attack
        @defense = defense
        @level = level
        @experience = experience
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