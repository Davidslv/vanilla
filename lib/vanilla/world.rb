require 'set'

module Vanilla
  # The game world that manages entities, systems, and game state
  class World
    attr_reader :entities, :systems, :event_manager

    # Initialize a new game world
    def initialize
      @entities = []
      @systems = []
      @event_manager = Events::EventManager.new
    end

    # Add an entity to the world
    #
    # @param entity [Entity] The entity to add
    def add_entity(entity)
      @entities << entity
      entity.world = self
    end

    # Remove an entity from the world
    #
    # @param entity [Entity] The entity to remove
    def remove_entity(entity)
      @entities.delete(entity)
      entity.world = nil
    end

    # Add a system to the world
    #
    # @param system [BaseSystem] The system to add
    def add_system(system)
      @systems << system
      system.world = self
    end

    # Process input and update all systems
    #
    # @param input [String] The keyboard input
    def update(input)
      # First process input through the input system
      input_system = @systems.find { |sys| sys.is_a?(Systems::InputSystem) }
      if input_system
        input_system.update(input)
      end

      # Then update other systems
      @systems.each do |system|
        next if system == input_system
        system.update(0.0) # Delta time not used yet
      end
    end

    # Find entities with a specific component type
    #
    # @param component_type [Class] The type of component to search for
    # @return [Array<Entity>] Entities that have the specified component
    def find_entities_with_component(component_type)
      @entities.select { |entity| entity.has_component?(component_type) }
    end

    # Find a single entity with a specific component type
    #
    # @param component_type [Class] The type of component to search for
    # @return [Entity, nil] The first entity found with the specified component
    def find_entity_with_component(component_type)
      @entities.find { |entity| entity.has_component?(component_type) }
    end
  end
end 