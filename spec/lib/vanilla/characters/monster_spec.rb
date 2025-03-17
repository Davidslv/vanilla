require 'spec_helper'
require 'vanilla/characters/monster'
require 'vanilla/map_utils/grid'

RSpec.describe Vanilla::Characters::Monster do
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, columns: 3) }
  let(:monster) { described_class.new(row: 1, column: 1, grid: grid) }

  describe '#initialize' do
    it 'creates a monster with default stats' do
      expect(monster.health).to eq(20)
      expect(monster.max_health).to eq(20)
      expect(monster.attack).to eq(5)
      expect(monster.defense).to eq(2)
    end

    it 'sets the correct tile type' do
      expect(monster.tile).to eq(Vanilla::Support::TileType::MONSTER)
    end
  end

  describe '#take_damage' do
    it 'reduces health by the damage amount minus defense' do
      monster.take_damage(10)
      expect(monster.health).to eq(12)
    end

    it 'does not reduce health below 0' do
      monster.take_damage(100)
      expect(monster.health).to eq(0)
    end

    it 'returns the actual damage taken' do
      expect(monster.take_damage(10)).to eq(8)
    end
  end

  describe '#attack_target' do
    let(:target) { double('target') }

    it 'calls take_damage on the target with the monster\'s attack value' do
      expect(target).to receive(:take_damage).with(monster.attack)
      monster.attack_target(target)
    end
  end

  describe '#alive?' do
    it 'returns true when health is greater than 0' do
      expect(monster.alive?).to be_truthy
    end

    it 'returns false when health is 0' do
      monster.take_damage(100)
      expect(monster.alive?).to be_falsey
    end
  end
end 