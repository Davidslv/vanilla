require 'spec_helper'
require 'vanilla/systems/input_system'
require 'vanilla/world'
require 'vanilla/entity'
require 'vanilla/commands/movement_command'

RSpec.describe Vanilla::Systems::InputSystem do
  let(:world) { Vanilla::World.new }
  let(:player) { Vanilla::Entity.new }
  let(:system) { described_class.new(world) }

  before do
    world.add_entity(player)
    allow(system).to receive(:find_player).and_return(player)
  end

  describe '#process_input' do
    context 'with movement keys' do
      it 'creates movement command for h key' do
        expect(Vanilla::Commands::MovementCommand).to receive(:new)
          .with(world: world, entity: player, direction: :left)
        system.process_input('h')
      end

      it 'creates movement command for j key' do
        expect(Vanilla::Commands::MovementCommand).to receive(:new)
          .with(world: world, entity: player, direction: :down)
        system.process_input('j')
      end

      it 'creates movement command for k key' do
        expect(Vanilla::Commands::MovementCommand).to receive(:new)
          .with(world: world, entity: player, direction: :up)
        system.process_input('k')
      end

      it 'creates movement command for l key' do
        expect(Vanilla::Commands::MovementCommand).to receive(:new)
          .with(world: world, entity: player, direction: :right)
        system.process_input('l')
      end
    end

    context 'with quit key' do
      it 'emits quit_game event' do
        expect(world.event_manager).to receive(:trigger).with(:quit_game)
        system.process_input('q')
      end
    end

    context 'with invalid key' do
      it 'emits invalid_command event' do
        expect(world.event_manager).to receive(:trigger).with(:invalid_command, key: 'x')
        system.process_input('x')
      end
    end
  end

  describe '#update' do
    let(:command) { instance_double(Vanilla::Commands::MovementCommand) }

    before do
      allow(Vanilla::Commands::MovementCommand).to receive(:new).and_return(command)
      allow(command).to receive(:can_execute?).and_return(true)
      allow(command).to receive(:execute).and_return(true)
    end

    it 'executes queued commands' do
      system.process_input('h')
      expect(command).to receive(:execute)
      system.update
    end

    it 'emits command_failed event when command cannot execute' do
      allow(command).to receive(:can_execute?).and_return(false)
      system.process_input('h')
      expect(world.event_manager).to receive(:trigger).with(:command_failed)
      system.update
    end

    it 'clears the command queue after execution' do
      system.process_input('h')
      system.update
      expect(system.instance_variable_get(:@command_queue)).to be_empty
    end
  end

  describe '#find_player' do
    it 'returns the player entity from the world' do
      real_system = described_class.new(world)
      expect(real_system.send(:find_player)).to eq(player)
    end
  end
end 