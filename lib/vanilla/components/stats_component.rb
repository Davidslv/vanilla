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
    class StatsComponent < BaseComponent
      attr_reader :health, :max_health, :attack, :defense, :level, :experience, :next_level_exp

      # Initialize a new StatsComponent
      #
      # @param entity [Entity] The entity this component belongs to
      # @param options [Hash] Stats options
      # @option options [Integer] :health Starting health (default: 100)
      # @option options [Integer] :max_health Maximum health (default: 100)
      # @option options [Integer] :attack Attack power (default: 10)
      # @option options [Integer] :defense Defense power (default: 5)
      # @option options [Integer] :level Starting level (default: 1)
      # @option options [Integer] :experience Starting experience (default: 0)
      def initialize(entity, options = {})
        super()
        @entity = entity
        @max_health = options[:max_health] || 100
        @health = options[:health] || @max_health
        @attack = options[:attack] || 10
        @defense = options[:defense] || 5
        @level = options[:level] || 1
        @experience = options[:experience] || 0
        calculate_next_level_exp
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

      # Heal the entity
      #
      # @param amount [Integer] Amount to heal
      # @return [Integer] Actual amount healed
      def heal(amount)
        return 0 unless alive?
        old_health = @health
        @health = [@health + amount, @max_health].min
        @health - old_health
      end

      # Adds experience points and handles level up if necessary
      #
      # @param amount [Integer] The amount of experience to gain
      # @return [Boolean] true if leveled up
      def gain_experience(amount)
        @experience += amount
        if @experience >= @next_level_exp
          level_up
          true
        else
          false
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
        @experience -= @next_level_exp
        improve_stats
        calculate_next_level_exp
      end

      def improve_stats
        @max_health += 10
        @health = @max_health
        @attack += 2
        @defense += 1
      end

      # Calculate experience needed for next level
      def calculate_next_level_exp
        @next_level_exp = @level * 100
      end
    end
  end
end 