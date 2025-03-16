require 'spec_helper'
require 'vanilla/characters/player'
require 'vanilla/map_utils/grid'

RSpec.describe Vanilla::Characters::Player do
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, columns: 3) }
  let(:player) { described_class.new(row: 1, column: 1, grid: grid) }

  describe '#initialize' do
    it 'creates a player with default stats' do
      expect(player.health).to eq(50)
      expect(player.max_health).to eq(50)
      expect(player.attack).to eq(10)
      expect(player.defense).to eq(5)
      expect(player.level).to eq(1)
      expect(player.experience).to eq(0)
    end

    it 'sets the correct tile type' do
      expect(player.tile).to eq(Support::TileType::PLAYER)
    end
  end

  describe '#take_damage' do
    it 'reduces health by the damage amount' do
      player.take_damage(10)
      expect(player.health).to eq(40)
    end

    it 'does not reduce health below 0' do
      player.take_damage(100)
      expect(player.health).to eq(0)
    end

    it 'returns the actual damage taken' do
      expect(player.take_damage(10)).to eq(10)
    end
  end

  describe '#attack_target' do
    let(:target) { double('target') }

    it 'calls take_damage on the target with the player\'s attack value' do
      expect(target).to receive(:take_damage).with(player.attack)
      player.attack_target(target)
    end
  end

  describe '#gain_experience' do
    it 'increases experience by the given amount' do
      player.gain_experience(10)
      expect(player.experience).to eq(10)
    end

    it 'levels up when experience reaches 100' do
      player.gain_experience(100)
      expect(player.level).to eq(2)
      expect(player.experience).to eq(0)
    end

    it 'increases stats when leveling up' do
      player.gain_experience(100)
      expect(player.max_health).to eq(60)
      expect(player.health).to eq(60)
      expect(player.attack).to eq(12)
      expect(player.defense).to eq(6)
    end
  end

  describe '#alive?' do
    it 'returns true when health is greater than 0' do
      expect(player.alive?).to be_truthy
    end

    it 'returns false when health is 0' do
      player.take_damage(100)
      expect(player.alive?).to be_falsey
    end
  end
end 