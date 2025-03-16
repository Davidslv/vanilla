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

  before do
    # Set up walls around the edges
    (0..2).each do |i|
      grid.cell(0, i).tile = Vanilla::Support::TileType::WALL  # Top wall
      grid.cell(2, i).tile = Vanilla::Support::TileType::WALL  # Bottom wall
      grid.cell(i, 0).tile = Vanilla::Support::TileType::WALL  # Left wall
      grid.cell(i, 2).tile = Vanilla::Support::TileType::WALL  # Right wall
    end
  end

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
        command.process('w')
        expect(player.row).to eq(1)
        expect(player.column).to eq(1)
      end

      it 'adds a collision message' do
        command.process('w')
        expect(terminal.messages).to include('You hit a wall!')
      end
    end

    context 'when encountering a monster' do
      before do
        grid.cell(1, 2).tile = Vanilla::Support::TileType::MONSTER
      end

      it 'initiates combat' do
        expect(command).to receive(:initiate_combat).with(monster)
        command.process('d') # move right
      end
    end

    context 'when finding stairs' do
      before do
        grid.cell(1, 2).tile = Vanilla::Support::TileType::STAIRS
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



end 