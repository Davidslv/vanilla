require 'spec_helper'
require 'vanilla/draw'

RSpec.describe Vanilla::Draw do
  describe '.tile' do
    let(:grid) { double('grid') }
    let(:row) { 1 }
    let(:column) { 2 }
    let(:tile) { :wall }

    it 'calls the tile method with correct arguments' do
      expect(described_class).to receive(:tile).with(grid: grid, row: row, column: column, tile: tile)
      described_class.tile(grid: grid, row: row, column: column, tile: tile)
    end

    it 'handles different tile types' do
      [:floor, :player, :stairs].each do |tile_type|
        expect(described_class).to receive(:tile).with(grid: grid, row: row, column: column, tile: tile_type)
        described_class.tile(grid: grid, row: row, column: column, tile: tile_type)
      end
    end

    it 'handles edge cases for row and column' do
      expect(described_class).to receive(:tile).with(grid: grid, row: 0, column: 0, tile: tile)
      described_class.tile(grid: grid, row: 0, column: 0, tile: tile)

      expect(described_class).to receive(:tile).with(grid: grid, row: 100, column: 100, tile: tile)
      described_class.tile(grid: grid, row: 100, column: 100, tile: tile)
    end

    it 'raises an error for invalid tile type' do
      expect {
        described_class.tile(grid: grid, row: row, column: column, tile: :invalid_tile)
      }.to raise_error(ArgumentError, /Invalid tile type/)
    end
  end
end
