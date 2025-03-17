# Base class for all components in the entity component system.
# Components are used to add behavior and data to entities in a modular way.
#
# @abstract Subclass and override {#initialize} to implement a custom component
module Vanilla
  module Components
    class BaseComponent
      # @return [Entity] The entity this component is attached to
      attr_accessor :entity

      # @param entity [Entity] The entity to attach this component to
      def initialize(entity)
        @entity = entity
      end

      # Called every game tick (frame) to update the component's state.
      # A game tick is a single iteration of the game loop where all game objects
      # are updated. Components that need continuous updates (like AI behavior,
      # automatic healing over time, or periodic status effects) should override
      # this method.
      #
      # @example
      #   class RegenerationComponent < BaseComponent
      #     def update
      #       # Heal 1 HP every tick if health is below max
      #       stats = entity.get_component(StatsComponent)
      #       if stats.health < stats.max_health
      #         stats.heal(1)
      #       end
      #     end
      #   end
      #
      # @note This method is called automatically by the game loop.
      #       Do not call this method directly unless you know what you're doing.
      def update
        # Optional: Override in specific components if they need per-tick updates
      end
    end
  end
end 