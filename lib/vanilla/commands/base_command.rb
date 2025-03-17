module Vanilla
  module Commands
    # Base class for all commands in the game
    # Commands represent individual actions that can be taken in the game
    class BaseCommand
      attr_reader :world, :entity

      def initialize(world:, entity:)
        @world = world
        @entity = entity
      end

      # Execute the command
      # @return [Boolean] true if command was successful, false otherwise
      def execute
        raise NotImplementedError, "#{self.class} must implement execute"
      end

      # Check if the command can be executed
      # @return [Boolean] true if command can be executed, false otherwise
      def can_execute?
        true
      end

      protected

      # Helper method to emit events
      def emit_event(event_type, **data)
        world.event_manager.trigger(event_type, data.merge(entity: entity))
      end

      # Helper method to get entity components
      def get_component(component_class)
        entity.get_component(component_class)
      end
    end
  end
end 