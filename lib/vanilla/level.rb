module Vanilla
  class Level
    require_relative 'support/tile_type'
    attr_reader :grid, :player, :monsters, :terminal

    def initialize(grid:, player: nil, terminal: nil)
      @grid = grid
      @player = player || Characters::Player.new(row: 1, column: 1, grid: @grid)
      @terminal = terminal || Output::Terminal.new(grid: grid, player: @player)
      @monsters = []
      place_stairs
      place_monsters
    end

    def self.random(player: nil)
      rows = rand(10..20)
      columns = rand(10..20)
      seed = rand(999_999_999_999_999)
      grid = Map.create(rows: rows, columns: columns, algorithm: Algorithms::BinaryTree, seed: seed)
      new(grid: grid, player: player)
    end

    def place_monsters
      num_monsters = (@grid.rows * @grid.columns) / 20
      num_monsters.times do
        row = rand(1..@grid.rows - 2)
        column = rand(1..@grid.columns - 2)
        cell = @grid.cell(row, column)
        if cell.tile == Vanilla::Support::TileType::FLOOR
          monster = Characters::Monster.new(row: row, column: column, grid: @grid)
          @monsters << monster
        end
      end
    end

    def place_stairs
      loop do
        row = rand(1..@grid.rows - 2)
        column = rand(1..@grid.columns - 2)
        cell = @grid.cell(row, column)
        if cell.tile == Vanilla::Support::TileType::FLOOR
          cell.tile = Vanilla::Support::TileType::STAIRS
          break
        end
      end
    end

    def update
      @terminal.clear
      @terminal.write
    end
  end
end
