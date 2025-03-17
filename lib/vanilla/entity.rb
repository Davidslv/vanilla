require_relative 'components/base_component'

module Vanilla
  class Entity
    def initialize
      @components = {}
    end

    def add_component(component_class, *args)
      component = component_class.new(self, *args)
      @components[component_class] = component
      component
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