require 'spec_helper'
require 'vanilla/commands/combat_command'
require 'vanilla/world'
require 'vanilla/entity'
require 'vanilla/components/transform_component'
require 'vanilla/components/combat_component'
require 'vanilla/components/stats_component'
require 'vanilla/map_utils/grid'

RSpec.describe Vanilla::Commands::CombatCommand do
  let(:world) { Vanilla::World.new }
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, columns: 3) }
  
  let(:attacker) { Vanilla::Entity.new }
  let(:attacker_transform) { Vanilla::Components::TransformComponent.new(attacker, grid, 1, 1) }
  let(:attacker_combat) { Vanilla::Components::CombatComponent.new(attacker, strength: 10) }
  
  let(:target) { Vanilla::Entity.new }
  let(:target_transform) { Vanilla::Components::TransformComponent.new(target, grid, 1, 2) }
  let(:target_stats) { Vanilla::Components::StatsComponent.new(target, hp: 20, max_hp: 20, level: 1) }
  
  before do
    attacker.add_component(attacker_transform)
    attacker.add_component(attacker_combat)
    world.add_entity(attacker)
    
    target.add_component(target_transform)
    target.add_component(target_stats)
    world.add_entity(target)
  end

  describe '#can_execute?' do
    it 'returns true when entities are adjacent' do
      command = described_class.new(world: world, entity: attacker, target: target)
      expect(command.can_execute?).to be true
    end

    it 'returns false when entities are not adjacent' do
      target_transform.move_to(2, 2)
      command = described_class.new(world: world, entity: attacker, target: target)
      expect(command.can_execute?).to be false
    end

    it 'returns false when attacker has no combat component' do
      attacker.remove_component(attacker_combat)
      command = described_class.new(world: world, entity: attacker, target: target)
      expect(command.can_execute?).to be false
    end

    it 'returns false when target has no stats component' do
      target.remove_component(target_stats)
      command = described_class.new(world: world, entity: attacker, target: target)
      expect(command.can_execute?).to be false
    end
  end

  describe '#execute' do
    let(:command) { described_class.new(world: world, entity: attacker, target: target) }

    it 'deals damage to target' do
      expect { command.execute }.to change { target_stats.hp }.by(-10)
    end

    it 'emits combat_executed event' do
      expect(world.event_manager).to receive(:trigger).with(:combat_executed, hash_including(damage: 10))
      command.execute
    end

    context 'when target survives' do
      it 'emits target_survived event' do
        expect(world.event_manager).to receive(:trigger).with(:target_survived, hash_including(target: target))
        command.execute
      end
    end

    context 'when target is defeated' do
      before do
        target_stats.hp = 5
      end

      it 'emits target_defeated event' do
        expect(world.event_manager).to receive(:trigger).with(:target_defeated, hash_including(target: target))
        command.execute
      end

      it 'awards experience to attacker' do
        expect(world.event_manager).to receive(:trigger).with(:experience_gained, hash_including(amount: kind_of(Integer)))
        command.execute
      end

      it 'removes target from world' do
        expect(world).to receive(:remove_entity).with(target)
        command.execute
      end
    end
  end
end 