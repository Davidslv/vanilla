require 'spec_helper'
require 'vanilla/support/tile_type'

RSpec.describe Vanilla::Support::TileType do
  describe 'constants' do
    it 'defines all required tile types' do
      expect(described_class.constants).to include(:FLOOR)
      expect(described_class.constants).to include(:WALL)
      expect(described_class.constants).to include(:PLAYER)
      expect(described_class.constants).to include(:MONSTER)
      expect(described_class.constants).to include(:STAIRS)
    end

    it 'defines tile types with correct values' do
      expect(described_class::FLOOR).to eq('.')
      expect(described_class::WALL).to eq('#')
      expect(described_class::PLAYER).to eq('@')
      expect(described_class::MONSTER).to eq('M')
      expect(described_class::STAIRS).to eq('%')
    end
  end

  describe '.valid?' do
    it 'returns true for valid tile types' do
      expect(described_class.valid?(described_class::FLOOR)).to be_truthy
      expect(described_class.valid?(described_class::WALL)).to be_truthy
      expect(described_class.valid?(described_class::PLAYER)).to be_truthy
      expect(described_class.valid?(described_class::MONSTER)).to be_truthy
      expect(described_class.valid?(described_class::STAIRS)).to be_truthy
    end

    it 'returns false for invalid tile types' do
      expect(described_class.valid?('X')).to be_falsey
      expect(described_class.valid?('Y')).to be_falsey
      expect(described_class.valid?(' ')).to be_falsey
    end
  end

  describe '.tile_to_s' do
    it 'returns the string representation of a tile type' do
      expect(described_class.tile_to_s(described_class::FLOOR)).to eq('.')
      expect(described_class.tile_to_s(described_class::WALL)).to eq('#')
      expect(described_class.tile_to_s(described_class::PLAYER)).to eq('@')
      expect(described_class.tile_to_s(described_class::MONSTER)).to eq('M')
      expect(described_class.tile_to_s(described_class::STAIRS)).to eq('>')
    end

    it 'raises an error for invalid tile types' do
      expect { described_class.tile_to_s('X') }.to raise_error(ArgumentError, /Invalid tile type/)
    end
  end
end 