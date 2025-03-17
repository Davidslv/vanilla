require 'spec_helper'

RSpec.describe Vanilla::Components::TransformComponent do
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 5, columns: 5) }
  let(:entity) { Vanilla::Entity.new }
  let(:transform) { described_class.new(entity, grid, 1, 1) }

  describe '#initialize' do
    it 'sets initial position and grid' do
      expect(transform.row).to eq(1)
      expect(transform.column).to eq(1)
      expect(transform.grid).to eq(grid)
      expect(grid.cell_at(1, 1).content).to eq(entity)
    end
  end

  describe '#move_to' do
    context 'when moving to a valid position' do
      it 'updates position and returns true' do
        expect(transform.move_to(2, 2)).to be true
        expect(transform.row).to eq(2)
        expect(transform.column).to eq(2)
        expect(grid.cell_at(2, 2).content).to eq(entity)
        expect(grid.cell_at(1, 1).content).to be_nil
      end
    end

    context 'when moving to an invalid position' do
      it 'returns false and maintains position' do
        expect(transform.move_to(-1, -1)).to be false
        expect(transform.row).to eq(1)
        expect(transform.column).to eq(1)
        expect(grid.cell_at(1, 1).content).to eq(entity)
      end
    end

    context 'when moving to a wall' do
      before do
        grid.cell_at(2, 2).tile = Vanilla::Support::TileType::WALL
      end

      it 'returns false and maintains position' do
        expect(transform.move_to(2, 2)).to be false
        expect(transform.row).to eq(1)
        expect(transform.column).to eq(1)
        expect(grid.cell_at(1, 1).content).to eq(entity)
      end
    end
  end
end 