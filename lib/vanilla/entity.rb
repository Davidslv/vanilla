require 'securerandom'
require_relative 'components/base_component'

module Vanilla
  class ComponentError < StandardError; end

  # Base class for all game entities (players, monsters, items)
  class Entity
    attr_reader :id, :components

    def initialize
      @id = SecureRandom.uuid
      @components = {}
    end

    # Adds a component to the entity
    #
    # @param component [BaseComponent] The component to add
    # @raise [ComponentError] If the component is nil or not a BaseComponent
    # @return [BaseComponent] The added component
    def add_component(component)
      validate_component(component)
      
      component.entity = self
      @components[component.class] = component
    end

    # Removes a component from the entity
    #
    # @param component [BaseComponent] The component to remove
    # @raise [ComponentError] If the component is nil or not a BaseComponent
    # @return [BaseComponent, nil] The removed component or nil if not found
    def remove_component(component)
      validate_component(component)
      @components.delete(component.class)
    end

    # Gets a component of the specified class
    #
    # @param component_class [Class] The class of the component to get
    # @raise [ComponentError] If component_class is nil
    # @return [BaseComponent, nil] The component or nil if not found
    def get_component(component_class)
      raise ComponentError, "Component class cannot be nil" if component_class.nil?
      @components[component_class]
    end

    # Checks if the entity has a component of the specified class
    #
    # @param component_class [Class] The class of the component to check for
    # @raise [ComponentError] If component_class is nil
    # @return [Boolean] true if the entity has the component, false otherwise
    def has_component?(component_class)
      raise ComponentError, "Component class cannot be nil" if component_class.nil?
      @components.key?(component_class)
    end

    # Updates all components attached to this entity
    def update
      @components.each_value(&:update)
    end

    private

    def validate_component(component)
      raise ComponentError, "Component cannot be nil" if component.nil?
      unless component.is_a?(Components::BaseComponent)
        raise ComponentError, "Component must be a BaseComponent"
      end
    end
  end
end 