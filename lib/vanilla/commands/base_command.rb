module Vanilla
  module Commands
    # Base class for all game commands
    class BaseCommand
      attr_reader :world, :entity

      # Initialize a new command
      #
      # @param world [World] The game world
      # @param entity [Entity] The entity executing the command
      def initialize(world, entity)
        @world = world
        @entity = entity
      end

      # Check if the command can be executed
      #
      # @return [Boolean] true if the command can be executed
      def can_execute?
        raise NotImplementedError, "#{self.class} must implement can_execute?"
      end

      # Execute the command
      #
      # @return [Boolean] true if the command was executed successfully
      def execute
        raise NotImplementedError, "#{self.class} must implement execute"
      end

      protected

      # Emit an event through the world's event manager
      #
      # @param event_name [Symbol] The name of the event
      # @param data [Hash] Additional data for the event
      def emit_event(event_name, data = {})
        world.event_manager.trigger(event_name, data)
      end

      # Helper method to get entity components
      def get_component(component_class)
        entity.get_component(component_class)
      end
    end
  end
end 