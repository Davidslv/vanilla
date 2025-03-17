require 'spec_helper'
require 'vanilla/systems/message_system'
require 'vanilla/world'
require 'vanilla/entity'

RSpec.describe Vanilla::Systems::MessageSystem do
  let(:world) { Vanilla::World.new }
  let(:system) { described_class.new(world) }
  let(:entity) { Vanilla::Entity.new }
  let(:target) { Vanilla::Entity.new }

  describe 'event handling' do
    context 'movement events' do
      it 'adds message for movement_completed' do
        system.send(:handle_movement_completed, to: [1, 2])
        expect(system.messages).to include('You move to position [1, 2]')
      end

      it 'adds message for hit_wall' do
        system.send(:handle_hit_wall)
        expect(system.messages).to include('You hit a wall')
      end
    end

    context 'combat events' do
      it 'adds message for combat_initiated' do
        system.send(:handle_combat_initiated, target: target)
        expect(system.messages).to include('Combat initiated with enemy')
      end

      it 'adds message for combat_executed' do
        system.send(:handle_combat_executed, damage: 10)
        expect(system.messages).to include('You deal 10 damage')
      end

      it 'adds message for target_survived' do
        system.send(:handle_target_survived, target: target)
        expect(system.messages).to include('The enemy survives the attack')
      end

      it 'adds message for target_defeated' do
        system.send(:handle_target_defeated, target: target)
        expect(system.messages).to include('You defeated the enemy')
      end

      it 'adds message for experience_gained' do
        system.send(:handle_experience_gained, amount: 50)
        expect(system.messages).to include('You gained 50 experience points')
      end
    end

    context 'stairs events' do
      it 'adds message for stairs_found' do
        system.send(:handle_stairs_found, entity: entity)
        expect(system.messages).to include('You found stairs leading to the next level')
      end
    end

    context 'command events' do
      it 'adds message for invalid_command' do
        system.send(:handle_invalid_command, key: 'x')
        expect(system.messages).to include('Invalid command: x')
      end

      it 'adds message for command_failed' do
        system.send(:handle_command_failed)
        expect(system.messages).to include('Cannot execute command')
      end
    end
  end

  describe '#messages' do
    it 'returns a copy of the messages array' do
      system.send(:add_message, 'Test message')
      messages = system.messages
      messages << 'New message'
      expect(system.messages).not_to include('New message')
    end
  end

  describe '#clear_messages' do
    it 'clears all messages' do
      system.send(:add_message, 'Test message')
      system.clear_messages
      expect(system.messages).to be_empty
    end
  end

  describe '#add_message' do
    it 'adds message and emits event' do
      expect(world.event_manager).to receive(:trigger).with(:message_added, message: 'Test message')
      system.send(:add_message, 'Test message')
      expect(system.messages).to include('Test message')
    end
  end
end 