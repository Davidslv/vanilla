require 'spec_helper'

RSpec.describe Vanilla::Components::StatsComponent do
  let(:entity) { Vanilla::Entity.new }
  let(:stats) { described_class.new(entity) }

  describe '#initialize' do
    context 'with default values' do
      it 'sets default stats' do
        expect(stats.health).to eq(100)
        expect(stats.max_health).to eq(100)
        expect(stats.attack).to eq(10)
        expect(stats.defense).to eq(5)
        expect(stats.level).to eq(1)
        expect(stats.experience).to eq(0)
      end
    end

    context 'with custom values' do
      let(:stats) { described_class.new(entity, health: 50, attack: 15) }

      it 'uses provided values and defaults for others' do
        expect(stats.health).to eq(50)
        expect(stats.max_health).to eq(100)
        expect(stats.attack).to eq(15)
        expect(stats.defense).to eq(5)
      end
    end
  end

  describe '#alive?' do
    it 'returns true when health > 0' do
      expect(stats).to be_alive
    end

    it 'returns false when health = 0' do
      stats.health = 0
      expect(stats).not_to be_alive
    end
  end

  describe '#take_damage' do
    it 'reduces health by damage minus defense' do
      damage_dealt = stats.take_damage(10)
      expect(damage_dealt).to eq(5) # 10 - 5 defense = 5
      expect(stats.health).to eq(95)
    end

    it 'ensures minimum damage of 1' do
      damage_dealt = stats.take_damage(3) # Would be -2 after defense
      expect(damage_dealt).to eq(1)
      expect(stats.health).to eq(99)
    end

    it 'prevents health from going below 0' do
      stats.take_damage(1000)
      expect(stats.health).to eq(0)
    end
  end

  describe '#heal' do
    before { stats.health = 50 }

    it 'increases health by the amount' do
      healed = stats.heal(20)
      expect(healed).to eq(20)
      expect(stats.health).to eq(70)
    end

    it 'does not heal above max_health' do
      healed = stats.heal(100)
      expect(healed).to eq(50) # Only healed up to max
      expect(stats.health).to eq(100)
    end

    it 'does not heal when dead' do
      stats.health = 0
      healed = stats.heal(50)
      expect(healed).to eq(0)
      expect(stats.health).to eq(0)
    end
  end

  describe '#gain_experience' do
    it 'increases experience' do
      stats.gain_experience(50)
      expect(stats.experience).to eq(50)
    end

    context 'when gaining enough experience to level up' do
      it 'levels up and improves stats' do
        old_max_health = stats.max_health
        old_attack = stats.attack
        old_defense = stats.defense

        stats.gain_experience(100) # Enough for level 2

        expect(stats.level).to eq(2)
        expect(stats.max_health).to eq(old_max_health + 10)
        expect(stats.health).to eq(stats.max_health)
        expect(stats.attack).to eq(old_attack + 2)
        expect(stats.defense).to eq(old_defense + 1)
      end

      it 'can level up multiple times' do
        stats.gain_experience(300) # Enough for multiple levels
        expect(stats.level).to be > 2
      end
    end
  end
end 