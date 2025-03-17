require 'spec_helper'
require 'vanilla/components/base_component'
require 'vanilla/entity'

RSpec.describe Vanilla::Components::BaseComponent do
  let(:entity) { Vanilla::Entity.new }
  let(:component) { described_class.new(entity) }

  describe '#initialize' do
    it 'sets the entity' do
      expect(component.entity).to eq(entity)
    end
  end

  describe '#update' do
    it 'provides a default empty implementation' do
      expect { component.update }.not_to raise_error
    end
  end

  describe 'entity association' do
    it 'allows changing the entity' do
      new_entity = Vanilla::Entity.new
      component.entity = new_entity
      expect(component.entity).to eq(new_entity)
    end
  end
end 