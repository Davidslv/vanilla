require 'spec_helper'
require 'vanilla/world'
require 'vanilla/entity'
require 'vanilla/systems/input_system'
require 'vanilla/systems/message_system'

RSpec.describe Vanilla::World do
  let(:world) { described_class.new }
  let(:entity) { Vanilla::Entity.new }

  describe '#initialize' do
    it 'creates empty entities array' do
      expect(world.entities).to be_empty
    end

    it 'creates event manager' do
      expect(world.event_manager).to be_a(Vanilla::EventManager)
    end

    it 'sets up default systems' do
      expect(world.systems).to include(
        an_instance_of(Vanilla::Systems::InputSystem),
        an_instance_of(Vanilla::Systems::MessageSystem)
      )
    end
  end

  describe '#add_entity' do
    it 'adds entity to the world' do
      world.add_entity(entity)
      expect(world.entities).to include(entity)
    end
  end

  describe '#remove_entity' do
    before { world.add_entity(entity) }

    it 'removes entity from the world' do
      world.remove_entity(entity)
      expect(world.entities).not_to include(entity)
    end
  end

  describe '#add_system' do
    let(:system) { instance_double('System') }

    it 'adds system to the world' do
      world.add_system(system)
      expect(world.systems).to include(system)
    end
  end

  describe '#update' do
    let(:system) { instance_double('System') }

    before do
      allow(system).to receive(:update)
      world.add_system(system)
    end

    it 'updates all systems' do
      expect(system).to receive(:update)
      world.update
    end
  end

  describe '#process_input' do
    let(:input_system) { world.systems.find { |s| s.is_a?(Vanilla::Systems::InputSystem) } }

    it 'delegates to input system' do
      expect(input_system).to receive(:process_input).with('h')
      world.process_input('h')
    end
  end

  describe '#messages' do
    let(:message_system) { world.systems.find { |s| s.is_a?(Vanilla::Systems::MessageSystem) } }

    before do
      message_system.send(:add_message, 'Test message')
    end

    it 'returns messages from message system' do
      expect(world.messages).to include('Test message')
    end
  end

  describe '#clear_messages' do
    let(:message_system) { world.systems.find { |s| s.is_a?(Vanilla::Systems::MessageSystem) } }

    before do
      message_system.send(:add_message, 'Test message')
    end

    it 'clears messages from message system' do
      world.clear_messages
      expect(world.messages).to be_empty
    end
  end
end 