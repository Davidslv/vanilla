require 'spec_helper'
require 'vanilla/map_utils/grid'
require 'vanilla/support/tile_type'

RSpec.describe Vanilla::MapUtils::Grid do
  let(:grid) { described_class.new(rows: 3, columns: 3) }

  describe '#initialize' do
    it 'creates a grid with the given dimensions' do
      expect(grid.rows).to eq(3)
      expect(grid.columns).to eq(3)
    end

    it 'creates cells for each position' do
      expect(grid.each_cell.count).to eq(9)
    end

    it 'initializes cells with FLOOR tile type' do
      grid.each_cell do |cell|
        expect(cell.tile).to eq(Support::TileType::FLOOR)
      end
    end

    it 'raises an ArgumentError when rows is less than 1' do
      expect { described_class.new(rows: 0, columns: 5) }.to raise_error(ArgumentError, "Rows must be greater than 0")
    end

    it 'raises an ArgumentError when columns is less than 1' do
      expect { described_class.new(rows: 5, columns: 0) }.to raise_error(ArgumentError, "Columns must be greater than 0")
    end

    it 'initializes cells as instances of Vanilla::MapUtils::Cell' do
      grid = described_class.new(rows: 3, columns: 3)
      
      grid.each_cell do |cell|
        expect(cell).to be_an_instance_of(Vanilla::MapUtils::Cell)
      end
    end

    it 'sets correct row and column values for each cell' do
      grid = described_class.new(rows: 2, columns: 2)
      
      expect(grid[0, 0].row).to eq(0)
      expect(grid[0, 0].column).to eq(0)
      expect(grid[1, 1].row).to eq(1)
      expect(grid[1, 1].column).to eq(1)
    end

    it 'correctly sets neighboring cells' do
      grid = described_class.new(rows: 3, columns: 3)
      center_cell = grid[1, 1]
      
      expect(center_cell.north).to eq(grid[0, 1])
      expect(center_cell.south).to eq(grid[2, 1])
      expect(center_cell.east).to eq(grid[1, 2])
      expect(center_cell.west).to eq(grid[1, 0])
    end

    it 'initializes monsters array as empty' do
      grid = described_class.new(rows: 3, columns: 3)
      expect(grid.monsters).to be_empty
    end
  end

  describe '#cell' do
    it 'returns the cell at the given position' do
      cell = grid.cell(1, 2)
      expect(cell.row).to eq(1)
      expect(cell.column).to eq(2)
    end

    it 'returns nil for out of bounds position' do
      expect(grid.cell(-1, 0)).to be_nil
      expect(grid.cell(0, -1)).to be_nil
      expect(grid.cell(3, 0)).to be_nil
      expect(grid.cell(0, 3)).to be_nil
    end
  end

  describe '#each_cell' do
    it 'yields each cell in the grid' do
      cells = []
      grid.each_cell { |cell| cells << cell }
      expect(cells.length).to eq(9)
      expect(cells.first).to be_a(Vanilla::MapUtils::Cell)
    end
  end

  describe '#each_row' do
    it 'yields each row in the grid' do
      rows = []
      grid.each_row { |row| rows << row }
      expect(rows.length).to eq(3)
      expect(rows.first.length).to eq(3)
      expect(rows.first.first).to be_a(Vanilla::MapUtils::Cell)
    end
  end

  describe '#random_cell' do
    it 'returns a random cell from the grid' do
      cell = grid.random_cell
      expect(cell).to be_a(Vanilla::MapUtils::Cell)
      expect(cell.row).to be_between(0, 2)
      expect(cell.column).to be_between(0, 2)
    end
  end

  describe '#dead_ends' do
    it 'returns an array of dead end cells' do
      cell = grid.cell(1, 1)
      cell.dead_end = true
      expect(grid.dead_ends).to include(cell)
    end

    it 'returns an empty array when no dead ends exist' do
      expect(grid.dead_ends).to be_empty
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the grid' do
      grid.cell(0, 0).tile = Support::TileType::WALL
      grid.cell(1, 1).tile = Support::TileType::PLAYER
      grid.cell(2, 2).tile = Support::TileType::STAIRS
      expect(grid.to_s).to include('#')
      expect(grid.to_s).to include('@')
      expect(grid.to_s).to include('%')
    end
  end

  describe 'size' do
    it 'returns the total number of cells in the grid' do
      grid = described_class.new(rows: 3, columns: 3)
      expect(grid.size).to eq(9)
    end
  end

  describe 'contents_of' do
    let(:cell) { grid[1, 1] }

    it 'returns space for a floor cell' do
      expect(grid.contents_of(cell)).to eq(" ")
    end

    it 'returns PLAYER for a cell with a player' do
      cell.tile = Support::TileType::PLAYER
      expect(grid.contents_of(cell)).to eq(Support::TileType::PLAYER)
    end

    it 'returns MONSTER for a cell with a monster' do
      cell.tile = Support::TileType::MONSTER
      expect(grid.contents_of(cell)).to eq(Support::TileType::MONSTER)
    end

    it 'returns STAIRS for a cell with stairs' do
      cell.tile = Support::TileType::STAIRS
      expect(grid.contents_of(cell)).to eq(Support::TileType::STAIRS)
    end

    it 'returns distance value for a cell with distance information' do
      grid.distances = { cell => 10 }
      expect(grid.contents_of(cell)).to eq("a") # 10 in base36
    end
  end
end
