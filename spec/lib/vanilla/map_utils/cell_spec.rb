require 'spec_helper'
require 'vanilla/support/tile_type'
require 'vanilla/map_utils/cell'

RSpec.describe Vanilla::MapUtils::Cell do
  let(:row) { 1 }
  let(:column) { 2 }
  let(:cell) { described_class.new(row: row, column: column) }

  describe '.new' do
    it 'creates a new Cell instance' do
      expect(described_class.new(row: row, column: column)).to be_a(described_class)
    end
  end

  describe '#initialize' do
    it 'creates a cell with the given row and column' do
      expect(cell.row).to eq(row)
      expect(cell.column).to eq(column)
    end

    it 'initializes with default values' do
      expect(cell.tile).to eq(Vanilla::Support::TileType::FLOOR)
      expect(cell.dead_end).to be_falsey
    end
  end

  describe '#row' do
    it 'returns the row value' do
      expect(cell.row).to eq(row)
    end
  end

  describe '#column' do
    it 'returns the column value' do
      expect(cell.column).to eq(column)
    end
  end

  describe '#position' do
    it 'returns the position as an array' do
      expect(cell.position).to eq([row, column])
    end
  end

  describe '#link' do
    let(:linked_cell) { described_class.new(row: row + 1, column: column + 1) }

    it 'links this cell to another cell' do
      expect(cell.link(cell: linked_cell, bidirectional: true)).to eq(cell)
    end

    it 'links the other cell to this cell if bidirectional is true' do
      expect(linked_cell.link(cell: cell, bidirectional: true)).to eq(linked_cell)
    end

    it 'does not link the other cell to this cell if bidirectional is false' do
      expect(linked_cell.link(cell: cell, bidirectional: false)).to eq(linked_cell)
    end

    it 'does not link this cell to itself' do
      expect { cell.link(cell: cell, bidirectional: true) }.to raise_error(ArgumentError)
    end

    it 'does not link this cell to itself if bidirectional is false' do
      expect { cell.link(cell: cell, bidirectional: false) }.to raise_error(ArgumentError)
    end
  end

  describe '#unlink' do
    let(:linked_cell) { described_class.new(row: row + 1, column: column + 1) }

    before do
      cell.link(cell: linked_cell, bidirectional: true)
    end

    it 'unlinks this cell from another cell' do
      expect(cell.unlink(cell: linked_cell, bidirectional: true)).to eq(cell)
    end

    it 'unlinks the other cell from this cell if bidirectional is true' do
      expect(linked_cell.unlink(cell: cell, bidirectional: true)).to eq(linked_cell)
    end

    it 'does not unlink the other cell from this cell if bidirectional is false' do
      expect(linked_cell.unlink(cell: cell, bidirectional: false)).to eq(linked_cell)
    end
  end

  describe '#links' do
    let(:linked_cell) { described_class.new(row: row + 1, column: column + 1) }
    let(:linked_cell2) { described_class.new(row: row + 2, column: column + 2) }
    let(:linked_cell3) { described_class.new(row: row + 3, column: column + 3) }

    it 'returns an empty array if there are no linked cells' do
      expect(cell.links).to eq([])
    end

    it 'returns an array of linked cells' do
      cell.link(cell: linked_cell, bidirectional: true)
      cell.link(cell: linked_cell2, bidirectional: true)
      cell.link(cell: linked_cell3, bidirectional: true)

      expect(cell.links).to eq([linked_cell, linked_cell2, linked_cell3])
    end
  end

  describe '#linked?' do
    let(:linked_cell) { described_class.new(row: row + 1, column: column + 1) }

    it 'returns false if the cell is not linked' do
      expect(cell.linked?(linked_cell)).to be_falsey
    end

    it 'returns true if the cell is linked' do
      cell.link(cell: linked_cell, bidirectional: true)
      expect(cell.linked?(linked_cell)).to be_truthy
    end
  end

  describe '#dead_end?' do
    it 'returns true when dead_end is true' do
      cell.dead_end = true
      expect(cell.dead_end?).to be_truthy
    end

    it 'returns false when dead_end is false' do
      cell.dead_end = false
      expect(cell.dead_end?).to be_falsey
    end
  end

  describe '#player?' do
    let(:player_cell) { described_class.new(row: row + 1, column: column + 1) }

    it 'returns false if the cell does not contain the player' do
      expect(cell.player?).to be_falsey
    end

    it 'returns true if the cell contains the player' do
      player_cell.tile = Vanilla::Support::TileType::PLAYER
      expect(player_cell.player?).to be_truthy
    end
  end

  describe '#stairs?' do
    let(:stairs_cell) { described_class.new(row: row + 1, column: column + 1) }

    it 'returns false if the cell does not contain stairs' do
      expect(cell.stairs?).to be_falsey
    end

    it 'returns true if the cell contains stairs' do
      stairs_cell.tile = Vanilla::Support::TileType::STAIRS
      expect(stairs_cell.stairs?).to be_truthy
    end
  end

  describe '#monster?' do
    let(:monster_cell) { described_class.new(row: row + 1, column: column + 1) }

    it 'returns false if the cell does not contain a monster' do
      expect(cell.monster?).to be_falsey
    end

    it 'returns true if the cell contains a monster' do
      monster_cell.tile = Vanilla::Support::TileType::MONSTER
      expect(monster_cell.monster?).to be_truthy
    end
  end

  describe '#occupied?' do
    let(:player_cell) { described_class.new(row: row + 1, column: column + 1) }
    let(:monster_cell) { described_class.new(row: row + 2, column: column + 2) }
    let(:stairs_cell) { described_class.new(row: row + 3, column: column + 3) }

    it 'returns false if the cell is a floor' do
      expect(cell.occupied?).to be_falsey
    end

    it 'returns true if the cell contains a player' do
      player_cell.tile = Vanilla::Support::TileType::PLAYER
      expect(player_cell.occupied?).to be_truthy
    end

    it 'returns true if the cell contains a monster' do
      monster_cell.tile = Vanilla::Support::TileType::MONSTER
      expect(monster_cell.occupied?).to be_truthy
    end

    it 'returns true if the cell contains stairs' do
      stairs_cell.tile = Vanilla::Support::TileType::STAIRS
      expect(stairs_cell.occupied?).to be_truthy
    end
  end

  describe '#neighbors' do
    let(:north_cell) { described_class.new(row: row - 1, column: column) }
    let(:south_cell) { described_class.new(row: row + 1, column: column) }
    let(:east_cell) { described_class.new(row: row, column: column + 1) }
    let(:west_cell) { described_class.new(row: row, column: column - 1) }

    it 'returns an empty array if there are no neighboring cells' do
      expect(cell.neighbors).to eq([])
    end

    it 'returns an array of neighboring cells' do
      cell.north = north_cell
      cell.south = south_cell
      cell.east = east_cell
      cell.west = west_cell

      expect(cell.neighbors).to eq([north_cell, south_cell, east_cell, west_cell])
    end
  end

  describe '#distances' do
    let(:linked_cell) { described_class.new(row: row + 1, column: column + 1) }
    let(:linked_cell2) { described_class.new(row: row + 2, column: column + 2) }

    it 'returns a DistanceBetweenCells object' do
      cell.link(cell: linked_cell, bidirectional: true)
      cell.link(cell: linked_cell2, bidirectional: true)

      expect(cell.distances).to be_a(Vanilla::MapUtils::DistanceBetweenCells)
    end
  end

  describe '#to_s' do
    it 'returns the tile representation' do
      cell.tile = Vanilla::Support::TileType::WALL
      expect(cell.to_s).to eq('#')
    end

    it 'handles different tile types' do
      tile_types = {
        Vanilla::Support::TileType::FLOOR => '.',
        Vanilla::Support::TileType::WALL => '#',
        Vanilla::Support::TileType::PLAYER => '@',
        Vanilla::Support::TileType::MONSTER => 'M',
        Vanilla::Support::TileType::STAIRS => '%'
      }

      tile_types.each do |tile_type, representation|
        cell.tile = tile_type
        expect(cell.to_s).to eq(representation)
      end
    end
  end
end
