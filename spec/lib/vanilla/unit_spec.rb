require 'spec_helper'
require 'vanilla/unit'
require 'vanilla/map_utils/grid'
require 'vanilla/support/tile_type'

RSpec.describe Vanilla::Unit do
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, columns: 3) }
  let(:unit) { described_class.new(row: 1, column: 1, tile: Vanilla::Support::TileType::PLAYER, grid: grid) }

  describe '#initialize' do
    it 'creates a unit with the given position and tile type' do
      expect(unit.row).to eq(1)
      expect(unit.column).to eq(1)
      expect(unit.tile).to eq(Vanilla::Support::TileType::PLAYER)
      expect(unit.grid).to eq(grid)
    end

    it 'sets the tile type on the grid cell' do
      expect(grid.cell(1, 1).tile).to eq(Vanilla::Support::TileType::PLAYER)
    end
  end

  describe '#move_to' do
    it 'updates the unit\'s position' do
      unit.move_to(2, 2)
      expect(unit.row).to eq(2)
      expect(unit.column).to eq(2)
    end

    it 'updates the tile type on the new cell' do
      unit.move_to(2, 2)
      expect(grid.cell(2, 2).tile).to eq(Vanilla::Support::TileType::PLAYER)
    end

    it 'clears the tile type on the old cell' do
      unit.move_to(2, 2)
      expect(grid.cell(1, 1).tile).to eq(Vanilla::Support::TileType::FLOOR)
    end
  end

  describe '#found_stairs?' do
    it 'returns true when the unit is on stairs' do
      grid.cell(1, 1).tile = Vanilla::Support::TileType::STAIRS
      expect(unit.found_stairs?).to be_truthy
    end

    it 'returns false when the unit is not on stairs' do
      expect(unit.found_stairs?).to be_falsey
    end
  end

  describe '#take_damage' do
    it 'reduces health by the damage amount' do
      unit.take_damage(10)
      expect(unit.health).to eq(unit.max_health - 10)
    end

    it 'does not reduce health below 0' do
      unit.take_damage(1000)
      expect(unit.health).to eq(0)
    end

    it 'returns the actual damage taken' do
      damage = 10
      expect(unit.take_damage(damage)).to eq(damage - unit.defense)
    end
  end

  describe '#attack_target' do
    let(:target) { double('target') }

    it 'calls take_damage on the target with the unit\'s attack value' do
      expect(target).to receive(:take_damage).with(unit.attack)
      unit.attack_target(target)
    end
  end

  describe '#alive?' do
    it 'returns true when health is greater than 0' do
      expect(unit.alive?).to be_truthy
    end

    it 'returns false when health is 0' do
      unit.take_damage(1000)
      expect(unit.alive?).to be_falsey
    end
  end
end 