require 'spec_helper'
require 'vanilla/draw'
require 'vanilla/map_utils/grid'
require 'vanilla/characters/player'
require 'vanilla/characters/monster'
require 'vanilla/output/terminal'

RSpec.describe Vanilla::Draw do
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, columns: 3) }
  let(:terminal) { Vanilla::Output::Terminal.new(grid: grid) }
  let(:player) { Vanilla::Characters::Player.new(row: 1, column: 1, grid: grid) }
  let(:monster) { Vanilla::Characters::Monster.new(row: 2, column: 2, grid: grid) }

  describe '.map' do
    it 'draws the map with correct characters' do
      grid.cell_at(0, 0).tile = Vanilla::Support::TileType::WALL
      grid.cell_at(1, 1).tile = Vanilla::Support::TileType::FLOOR
      grid.cell_at(2, 2).tile = Vanilla::Support::TileType::STAIRS

      expect { described_class.map(grid) }.to output(/[#. >]/).to_stdout
    end
  end

  describe '.place_player' do
    it 'places the player on the grid' do
      described_class.place_player(grid: grid, player: player)
      expect(grid.cell_at(1, 1).tile).to eq(Vanilla::Support::TileType::PLAYER)
    end
  end

  describe '.place_monster' do
    it 'places the monster on the grid' do
      described_class.place_monster(grid: grid, monster: monster)
      expect(grid.cell_at(2, 2).tile).to eq(Vanilla::Support::TileType::MONSTER)
    end
  end

  describe '.display' do
    it 'displays the terminal output' do
      expect(terminal).to receive(:to_s)
      described_class.display(terminal: terminal)
    end
  end
end
