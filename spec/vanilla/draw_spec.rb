require 'spec_helper'

RSpec.describe Vanilla::Draw do
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, cols: 3) }
  let(:player) { double('player', row: 1, column: 1) }

  describe '.map' do
    it 'renders grid with proper boundaries' do
      # Set up a simple grid with a player
      grid.set(1, 1, Vanilla::Support::TileType::PLAYER)
      grid.set(1, 2, Vanilla::Support::TileType::FLOOR)
      
      # Capture the output
      output = capture_stdout { described_class.map(grid) }
      
      # Check that the player cell has proper boundaries
      expect(output).to include("| @ |")
      expect(output).to include("+---+")
    end
  end

  describe '.place_player' do
    it 'places player on grid' do
      described_class.place_player(grid: grid, player: player)
      expect(grid.cell_at(1, 1).tile).to eq(Vanilla::Support::TileType::PLAYER)
    end
  end

  describe '.place_monster' do
    it 'places monster on grid' do
      monster = double('monster', row: 2, column: 2)
      described_class.place_monster(grid: grid, monster: monster)
      expect(grid.cell_at(2, 2).tile).to eq(Vanilla::Support::TileType::MONSTER)
    end
  end

  describe '.stairs' do
    it 'places stairs on grid' do
      described_class.stairs(grid: grid, row: 2, column: 2)
      expect(grid.cell_at(2, 2).tile).to eq(Vanilla::Support::TileType::STAIRS)
    end
  end

  describe '.tile' do
    it 'raises error for invalid tile type' do
      expect {
        described_class.tile(grid: grid, row: 1, column: 1, tile: :invalid)
      }.to raise_error(ArgumentError, 'Invalid tile type')
    end

    it 'sets valid tile type' do
      described_class.tile(grid: grid, row: 1, column: 1, tile: Vanilla::Support::TileType::FLOOR)
      expect(grid.cell_at(1, 1).tile).to eq(Vanilla::Support::TileType::FLOOR)
    end
  end

  private

  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end
end 