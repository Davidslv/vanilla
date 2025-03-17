require_relative 'components/base_component'

module Vanilla
  # Base class for all game entities (players, monsters, items)
  class Entity
    attr_reader :id, :components

    def initialize
      @id = SecureRandom.uuid
      @components = {}
    end

    def add_component(component)
      @components[component.class] = component
      component.entity = self
    end

    def remove_component(component_class)
      @components.delete(component_class)
    end

    def get_component(component_class)
      @components[component_class]
    end

    def has_component?(component_class)
      @components.key?(component_class)
    end

    def update
      @components.each_value(&:update)
    end
  end
end 