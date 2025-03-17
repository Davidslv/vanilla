module Vanilla
  class Component
    attr_reader :entity

    def initialize(entity)
      @entity = entity
    end

    def update
      # Optional: Override in specific components if they need per-tick updates
    end
  end
end 