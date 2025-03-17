require 'spec_helper'
require 'vanilla/entity'
require 'vanilla/components/base_component'

RSpec.describe Vanilla::Entity do
  let(:entity) { described_class.new }
  let(:component_class) do
    Class.new(Vanilla::Components::BaseComponent) do
      attr_accessor :updated
      def update
        @updated = true
      end
    end
  end

  describe '#initialize' do
    it 'creates an empty components hash' do
      expect(entity.components).to be_empty
    end

    it 'generates a unique id' do
      other_entity = described_class.new
      expect(entity.id).not_to eq(other_entity.id)
    end
  end

  describe '#add_component' do
    let(:component) { component_class.new(entity) }

    it 'adds the component to the entity' do
      entity.add_component(component)
      expect(entity.get_component(component_class)).to eq(component)
    end

    it 'sets the entity reference in the component' do
      entity.add_component(component)
      expect(component.entity).to eq(entity)
    end

    it 'replaces existing component of the same class' do
      first_component = component_class.new(entity)
      second_component = component_class.new(entity)
      
      entity.add_component(first_component)
      entity.add_component(second_component)
      
      expect(entity.get_component(component_class)).to eq(second_component)
    end
  end

  describe '#remove_component' do
    let(:component) { component_class.new(entity) }

    before { entity.add_component(component) }

    it 'removes the component from the entity' do
      entity.remove_component(component)
      expect(entity.get_component(component_class)).to be_nil
    end
  end

  describe '#get_component' do
    let(:component) { component_class.new(entity) }

    before { entity.add_component(component) }

    it 'returns the component of the specified class' do
      expect(entity.get_component(component_class)).to eq(component)
    end

    it 'returns nil if component does not exist' do
      expect(entity.get_component(Class.new)).to be_nil
    end
  end

  describe '#has_component?' do
    let(:component) { component_class.new(entity) }

    before { entity.add_component(component) }

    it 'returns true if entity has the component' do
      expect(entity.has_component?(component_class)).to be true
    end

    it 'returns false if entity does not have the component' do
      expect(entity.has_component?(Class.new)).to be false
    end
  end

  describe '#update' do
    let(:component) { component_class.new(entity) }

    before { entity.add_component(component) }

    it 'updates all components' do
      entity.update
      expect(component.updated).to be true
    end
  end
end 