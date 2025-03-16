require 'spec_helper'
require 'vanilla/level'
require 'vanilla/map_utils/grid'
require 'vanilla/output/terminal'
require 'vanilla/support/tile_type'

RSpec.describe Vanilla::Level do
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, columns: 3) }
  let(:terminal) { Vanilla::Output::Terminal.new(grid: grid) }
  let(:level) { described_class.new(grid: grid, terminal: terminal) }

  describe '#initialize' do
    it 'creates a new level with a grid and terminal' do
      expect(level.grid).to eq(grid)
      expect(level.terminal).to eq(terminal)
    end

    it 'creates a player if none is provided' do
      expect(level.player).to be_a(Vanilla::Characters::Player)
    end

    it 'uses an existing player if provided' do
      player = Vanilla::Characters::Player.new(row: 1, column: 1, grid: grid)
      level = described_class.new(grid: grid, player: player, terminal: terminal)
      expect(level.player).to eq(player)
    end
  end

  describe '.random' do
    it 'creates a level with random dimensions' do
      level = described_class.random
      expect(level.grid.rows).to be_between(8, 20)
      expect(level.grid.columns).to be_between(8, 20)
    end

    it 'accepts an existing player' do
      player = Vanilla::Characters::Player.new(row: 1, column: 1, grid: grid)
      level = described_class.random(player: player)
      expect(level.player).to eq(player)
    end
  end

  describe '#place_monsters' do
    it 'places monsters on the level' do
      level.place_monsters
      monster_cells = grid.cells.flatten.count { |cell| cell.tile == Support::TileType::MONSTER }
      expect(monster_cells).to be_between(2, 4)
    end

    it 'does not place monsters on occupied cells' do
      level.place_monsters
      expect(grid[level.player.row, level.player.column].tile).not_to eq(Support::TileType::MONSTER)
    end
  end

  describe '#place_stairs' do
    it 'places stairs on the grid' do
      level.place_stairs
      stairs_cells = grid.each_cell.select { |cell| cell.tile == Support::TileType::STAIRS }
      expect(stairs_cells).not_to be_empty
    end

    it 'does not place stairs on walls or monsters' do
      grid.cell(0, 0).tile = Support::TileType::WALL
      grid.cell(2, 2).tile = Support::TileType::MONSTER
      level.place_stairs
      expect(grid.cell(0, 0).tile).to eq(Support::TileType::WALL)
      expect(grid.cell(2, 2).tile).to eq(Support::TileType::MONSTER)
    end

    it 'does not place stairs on the player' do
      level.place_stairs
      expect(grid.cell(level.player.row, level.player.column).tile).to eq(Support::TileType::PLAYER)
    end
  end

  describe '#update' do
    it 'clears the terminal and redraws the map' do
      expect(terminal).to receive(:clear)
      expect(Vanilla::Draw).to receive(:map).with(grid: grid)
      expect(Vanilla::Draw).to receive(:display).with(terminal: terminal)
      level.update
    end
  end
end 