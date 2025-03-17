require 'spec_helper'
require 'vanilla/commands/movement_command'
require 'vanilla/world'
require 'vanilla/entity'
require 'vanilla/components/transform_component'
require 'vanilla/map_utils/grid'

RSpec.describe Vanilla::Commands::MovementCommand do
  let(:world) { Vanilla::World.new }
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, columns: 3) }
  let(:entity) { Vanilla::Entity.new }
  let(:transform) { Vanilla::Components::TransformComponent.new(entity, grid, 1, 1) }
  
  before do
    entity.add_component(transform)
    world.add_entity(entity)
    
    # Link cells to allow movement
    grid.cell_at(1, 1).link(cell: grid.cell_at(0, 1)) # Link north
    grid.cell_at(1, 1).link(cell: grid.cell_at(2, 1)) # Link south
    grid.cell_at(1, 1).link(cell: grid.cell_at(1, 0)) # Link west
    grid.cell_at(1, 1).link(cell: grid.cell_at(1, 2)) # Link east
  end

  describe '#can_execute?' do
    it 'returns true for valid moves' do
      command = described_class.new(world: world, entity: entity, direction: :up)
      expect(command.can_execute?).to be true
    end

    it 'returns false for moves outside grid' do
      transform.move_to(0, 0)
      command = described_class.new(world: world, entity: entity, direction: :up)
      expect(command.can_execute?).to be false
    end

    it 'returns false for moves through unlinked cells' do
      grid.cell_at(1, 1).unlink(cell: grid.cell_at(0, 1))
      command = described_class.new(world: world, entity: entity, direction: :up)
      expect(command.can_execute?).to be false
    end
  end

  describe '#execute' do
    it 'moves entity to new position' do
      command = described_class.new(world: world, entity: entity, direction: :up)
      expect(command.execute).to be true
      expect(transform.position).to eq([0, 1])
    end

    it 'emits movement_completed event' do
      command = described_class.new(world: world, entity: entity, direction: :up)
      expect(world.event_manager).to receive(:trigger).with(:movement_completed, hash_including(to: [0, 1]))
      command.execute
    end

    context 'when moving to stairs' do
      before do
        grid.cell_at(0, 1).tile = Vanilla::Support::TileType::STAIRS
      end

      it 'emits stairs_found event' do
        command = described_class.new(world: world, entity: entity, direction: :up)
        expect(world.event_manager).to receive(:trigger).with(:stairs_found, hash_including(entity: entity))
        command.execute
      end
    end

    context 'when moving to monster' do
      let(:monster) { Vanilla::Entity.new }
      
      before do
        grid.cell_at(0, 1).tile = Vanilla::Support::TileType::MONSTER
        grid.cell_at(0, 1).content = monster
      end

      it 'emits combat_initiated event' do
        command = described_class.new(world: world, entity: entity, direction: :up)
        expect(world.event_manager).to receive(:trigger).with(:combat_initiated, hash_including(target: monster))
        command.execute
      end

      it 'does not complete movement' do
        command = described_class.new(world: world, entity: entity, direction: :up)
        expect(command.execute).to be false
        expect(transform.position).to eq([1, 1])
      end
    end
  end
end 