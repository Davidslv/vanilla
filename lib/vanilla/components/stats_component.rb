require_relative 'base_component'

module Vanilla
  module Components
    class StatsComponent < BaseComponent
      attr_accessor :health, :max_health, :attack, :defense, :level, :experience

      def initialize(entity, stats = {})
        super(entity)
        @health = stats[:health] || 100
        @max_health = stats[:max_health] || 100
        @attack = stats[:attack] || 10
        @defense = stats[:defense] || 5
        @level = stats[:level] || 1
        @experience = stats[:experience] || 0
      end

      def alive?
        @health > 0
      end

      def take_damage(amount)
        actual_damage = [amount - @defense, 1].max
        @health = [@health - actual_damage, 0].max
        actual_damage
      end

      def heal(amount)
        return 0 unless alive?
        old_health = @health
        @health = [@health + amount, @max_health].min
        @health - old_health
      end

      def gain_experience(amount)
        @experience += amount
        check_level_up
      end

      private

      def check_level_up
        while @experience >= experience_for_next_level
          @experience -= experience_for_next_level
          level_up
        end
      end

      def experience_for_next_level
        # Linear growth formula
        100 * @level
      end

      def level_up
        @level += 1
        @max_health += 10
        @health = @max_health
        @attack += 2
        @defense += 1
      end
    end
  end
end 