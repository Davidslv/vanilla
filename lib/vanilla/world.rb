require 'set'

module Vanilla
  # Manages all entities and systems in the game
  class World
    attr_reader :entities, :systems, :event_manager

    def initialize
      @entities = []
      @systems = []
      @event_manager = Events::EventManager.new
      setup_systems
    end

    def add_entity(entity)
      @entities << entity
    end

    def remove_entity(entity)
      @entities.delete(entity)
    end

    def add_system(system)
      @systems << system
    end

    def update
      @systems.each(&:update)
    end

    def process_input(key)
      input_system = @systems.find { |system| system.is_a?(Systems::InputSystem) }
      input_system&.process_input(key)
    end

    def messages
      message_system = @systems.find { |system| system.is_a?(Systems::MessageSystem) }
      message_system&.messages || []
    end

    def clear_messages
      message_system = @systems.find { |system| system.is_a?(Systems::MessageSystem) }
      message_system&.clear_messages
    end

    # Find entities with all specified components
    def entities_with_components(*component_classes)
      @entities.select do |entity|
        component_classes.all? { |klass| entity.has_component?(klass) }
      end
    end

    private

    def setup_systems
      add_system(Systems::InputSystem.new(self))
      add_system(Systems::MessageSystem.new(self))
    end
  end
end 