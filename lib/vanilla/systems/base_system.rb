module Vanilla
  module Systems
    # Base class for all systems in the game
    # Systems process entities with specific components
    class BaseSystem
      def initialize(world)
        @world = world
      end

      # Override this method to specify which components an entity needs
      # to be processed by this system
      def required_components
        []
      end

      # Returns all entities that can be processed by this system
      def matching_entities
        @world.entities.select do |entity|
          required_components.all? { |component| entity.has_component?(component) }
        end
      end

      # Override this method in specific systems
      def update(delta_time)
        raise NotImplementedError, "#{self.class} must implement update"
      end

      protected

      attr_reader :world
    end
  end
end 