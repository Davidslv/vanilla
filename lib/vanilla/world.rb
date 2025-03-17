require 'set'

module Vanilla
  # Manages all entities and systems in the game
  class World
    attr_reader :entities, :systems, :event_manager

    def initialize
      @entities = Set.new
      @systems = []
      @event_manager = Events::EventManager.new
      @to_add = []
      @to_remove = []
    end

    def add_entity(entity)
      @to_add << entity
    end

    def remove_entity(entity)
      @to_remove << entity
    end

    def add_system(system)
      @systems << system
    end

    def update(delta_time)
      # Process pending entity changes
      @to_add.each { |entity| @entities.add(entity) }
      @to_remove.each { |entity| @entities.delete(entity) }
      @to_add.clear
      @to_remove.clear

      # Update all systems
      @systems.each { |system| system.update(delta_time) }
    end

    # Find entities with all specified components
    def entities_with_components(*component_classes)
      @entities.select do |entity|
        component_classes.all? { |klass| entity.has_component?(klass) }
      end
    end
  end
end 