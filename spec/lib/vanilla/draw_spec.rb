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
    it 'draws the grid with correct tile types' do
      grid.cell(0, 0).tile = Vanilla::Support::TileType::WALL
      grid.cell(1, 1).tile = Vanilla::Support::TileType::FLOOR
      grid.cell(2, 2).tile = Vanilla::Support::TileType::STAIRS

      output = described_class.map(grid: grid)
      expect(output).to include('#')
      expect(output).to include('.')
      expect(output).to include('%')
    end
  end

  describe '.player' do
    it 'draws the player at the correct position' do
      described_class.player(grid: grid, unit: player, terminal: terminal)
      expect(grid.cell(1, 1).tile).to eq(Vanilla::Support::TileType::PLAYER)
    end
  end

  describe '.monster' do
    it 'draws the monster at the correct position' do
      described_class.monster(grid: grid, unit: monster, terminal: terminal)
      expect(grid.cell(2, 2).tile).to eq(Vanilla::Support::TileType::MONSTER)
    end
  end

  describe '.clear_screen' do
    it 'clears the terminal' do
      expect(terminal).to receive(:clear)
      described_class.clear_screen(terminal: terminal)
    end
  end

  describe '.display' do
    it 'displays the terminal output' do
      expect(terminal).to receive(:to_s)
      described_class.display(terminal: terminal)
    end
  end
end
