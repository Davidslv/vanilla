require_relative '../component'
require_relative 'stats_component'

module Vanilla
  module Components
    # Handles combat interactions between entities.
    # This component manages battle mechanics, including attacking,
    # damage calculation, and combat resolution.
    #
    # @example Initiating combat between two entities
    #   attacker_combat = attacker.get_component(CombatComponent)
    #   attacker_combat.attack(defender)
    class CombatComponent < Component
      # @return [Array<String>] List of combat messages generated during battle
      attr_reader :messages

      def initialize(entity)
        super
        @messages = []
      end

      # Initiates combat with a target entity
      #
      # @param target [Entity] The entity to attack
      # @return [Boolean] true if combat was successful, false otherwise
      def attack(target)
        return false unless can_attack?(target)

        attacker_stats = entity.get_component(StatsComponent)
        defender_stats = target.get_component(StatsComponent)

        return false unless attacker_stats && defender_stats

        # Calculate and apply damage
        damage_dealt = calculate_damage(attacker_stats, defender_stats)
        actual_damage = defender_stats.take_damage(damage_dealt)

        # Record combat message
        add_message("#{entity_name} strikes #{target_name(target)} for #{actual_damage} damage!")
        add_message("#{target_name(target)} has #{defender_stats.health} HP remaining.")

        # Check if target was defeated
        if !defender_stats.alive?
          handle_defeat(target)
        end

        true
      end

      private

      # Calculates damage based on attacker and defender stats
      #
      # @param attacker_stats [StatsComponent] The attacker's stats
      # @param defender_stats [StatsComponent] The defender's stats
      # @return [Integer] The calculated damage
      def calculate_damage(attacker_stats, defender_stats)
        # Base damage is attack power
        damage = attacker_stats.attack
        
        # Add some randomness (-2 to +2)
        damage += rand(-2..2)
        
        # Ensure minimum damage of 1
        [damage, 1].max
      end

      # Handles the defeat of a target
      #
      # @param target [Entity] The defeated entity
      def handle_defeat(target)
        defender_stats = target.get_component(StatsComponent)
        add_message("#{target_name(target)} has been defeated!")

        # If player defeated a monster, gain experience
        if target_name(target) == "Monster" && entity_name == "Player"
          experience = calculate_experience(defender_stats.level)
          attacker_stats = entity.get_component(StatsComponent)
          attacker_stats.gain_experience(experience)
          add_message("You gain #{experience} experience points!")
        end
      end

      # Calculates experience gained from defeating a monster
      #
      # @param monster_level [Integer] The level of the defeated monster
      # @return [Integer] The amount of experience gained
      def calculate_experience(monster_level)
        base_exp = 50
        level_bonus = monster_level * 10
        base_exp + level_bonus
      end

      # Checks if this entity can attack the target
      #
      # @param target [Entity] The potential target
      # @return [Boolean] true if attack is possible, false otherwise
      def can_attack?(target)
        return false unless target
        return false if target == entity # Can't attack self
        
        attacker_stats = entity.get_component(StatsComponent)
        defender_stats = target.get_component(StatsComponent)
        
        return false unless attacker_stats&.alive? && defender_stats&.alive?
        
        true
      end

      # Gets a display name for the entity
      #
      # @return [String] The entity's display name
      def entity_name
        entity.class.name.split("::").last
      end

      # Gets a display name for the target
      #
      # @param target [Entity] The target entity
      # @return [String] The target's display name
      def target_name(target)
        target.class.name.split("::").last
      end

      # Adds a message to the combat log
      #
      # @param message [String] The message to add
      def add_message(message)
        @messages << message
      end
    end
  end
end 