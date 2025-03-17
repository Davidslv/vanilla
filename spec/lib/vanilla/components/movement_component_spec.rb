require 'spec_helper'
require 'vanilla/components/movement_component'
require 'vanilla/map_utils/grid'
require 'vanilla/entity'
require 'vanilla/components/transform_component'

RSpec.describe Vanilla::Components::MovementComponent do
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, columns: 3) }
  let(:entity) { Vanilla::Entity.new }
  let(:transform) { Vanilla::Components::TransformComponent.new(entity, grid, 1, 1) }
  
  before do
    entity.add_component(transform)
  end

  subject(:movement) { described_class.new(entity) }

  describe '#move' do
    context 'when moving in valid directions' do
      before do
        # Link cells to allow movement
        grid.cell_at(1, 1).link(cell: grid.cell_at(0, 1)) # Link north
        grid.cell_at(1, 1).link(cell: grid.cell_at(2, 1)) # Link south
        grid.cell_at(1, 1).link(cell: grid.cell_at(1, 0)) # Link west
        grid.cell_at(1, 1).link(cell: grid.cell_at(1, 2)) # Link east
      end

      it 'moves north successfully' do
        expect(movement.move(:up)).to be true
        expect(transform.row).to eq(0)
        expect(transform.column).to eq(1)
      end

      it 'moves south successfully' do
        expect(movement.move(:down)).to be true
        expect(transform.row).to eq(2)
        expect(transform.column).to eq(1)
      end

      it 'moves west successfully' do
        expect(movement.move(:left)).to be true
        expect(transform.row).to eq(1)
        expect(transform.column).to eq(0)
      end

      it 'moves east successfully' do
        expect(movement.move(:right)).to be true
        expect(transform.row).to eq(1)
        expect(transform.column).to eq(2)
      end
    end

    context 'when moving in invalid directions' do
      it 'fails to move through unlinked cells' do
        expect(movement.move(:up)).to be false
        expect(transform.row).to eq(1)
        expect(transform.column).to eq(1)
      end

      it 'fails to move outside grid bounds' do
        transform.move_to(0, 0)
        expect(movement.move(:up)).to be false
        expect(transform.row).to eq(0)
        expect(transform.column).to eq(0)
      end
    end

    context 'when entity has no transform component' do
      let(:entity_without_transform) { Vanilla::Entity.new }
      subject(:invalid_movement) { described_class.new(entity_without_transform) }

      it 'returns false' do
        expect(invalid_movement.move(:up)).to be false
      end
    end
  end
end 