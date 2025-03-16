require 'spec_helper'
require 'vanilla/command'
require 'vanilla/map_utils/grid'
require 'vanilla/characters/player'
require 'vanilla/characters/monster'
require 'vanilla/output/terminal'

RSpec.describe Vanilla::Command do
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, columns: 3) }
  let(:terminal) { Vanilla::Output::Terminal.new(grid: grid) }
  let(:player) { Vanilla::Characters::Player.new(row: 1, column: 1, grid: grid) }
  let(:monster) { Vanilla::Characters::Monster.new(row: 2, column: 2, grid: grid) }
  let(:command) { described_class.new(player: player, terminal: terminal) }

  describe '#initialize' do
    it 'creates a command with the given player and terminal' do
      expect(command.player).to eq(player)
      expect(command.terminal).to eq(terminal)
    end
  end

  describe '#process' do
    context 'when moving to a valid position' do
      it 'moves the player and updates the grid' do
        command.process('w') # move up
        expect(player.row).to eq(0)
        expect(player.column).to eq(1)
      end

      it 'adds a movement message' do
        command.process('w')
        expect(terminal.messages).to include(/You move/)
      end
    end

    context 'when moving to an invalid position' do
      it 'does not move the player' do
        original_row = player.row
        original_column = player.column
        command.process('w') # move up
        command.process('w') # try to move up again
        expect(player.row).to eq(original_row - 1)
        expect(player.column).to eq(original_column)
      end

      it 'adds a collision message' do
        command.process('w')
        command.process('w')
        expect(terminal.messages).to include(/You bump into/)
      end
    end

    context 'when encountering a monster' do
      before do
        grid.cell(1, 2).tile = Support::TileType::MONSTER
      end

      it 'initiates combat' do
        expect(command).to receive(:initiate_combat).with(grid.cell(1, 2))
        command.process('d') # move right
      end
    end

    context 'when finding stairs' do
      before do
        grid.cell(1, 2).tile = Support::TileType::STAIRS
      end

      it 'sets found_stairs flag' do
        command.process('d') # move right
        expect(player.found_stairs?).to be_truthy
      end
    end

    context 'with invalid input' do
      it 'adds an invalid command message' do
        command.process('x')
        expect(terminal.messages).to include(/Invalid command/)
      end
    end
  end

  describe '#initiate_combat' do
    let(:monster_cell) { grid.cell(1, 2) }
    let(:monster) { Vanilla::Characters::Monster.new(row: 1, column: 2, grid: grid) }

    before do
      monster_cell.tile = Support::TileType::MONSTER
    end

    it 'starts combat with the monster' do
      expect(command).to receive(:combat_round).with(monster)
      command.initiate_combat(monster_cell)
    end

    it 'adds combat messages' do
      command.initiate_combat(monster_cell)
      expect(terminal.messages).to include(/You encounter/)
    end
  end

  describe '#combat_round' do
    let(:monster) { Vanilla::Characters::Monster.new(row: 1, column: 2, grid: grid) }

    it 'handles player attack' do
      expect(monster).to receive(:take_damage).with(player.attack)
      command.combat_round(monster)
    end

    it 'handles monster attack if alive' do
      allow(monster).to receive(:alive?).and_return(true)
      expect(player).to receive(:take_damage).with(monster.attack)
      command.combat_round(monster)
    end

    it 'adds combat messages' do
      command.combat_round(monster)
      expect(terminal.messages).to include(/You attack/)
      expect(terminal.messages).to include(/The monster attacks/)
    end
  end
end 