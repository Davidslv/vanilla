module Vanilla
  class Level
    require_relative 'support/tile_type'
    attr_reader :grid, :player, :monsters, :terminal

    MAX_ROWS = 10
    MAX_COLUMNS = 10

    def initialize(grid:, player:, terminal: nil)
      @grid = grid
      @player = player
      @terminal = terminal || Output::Terminal.new(grid: grid, player: @player)
      @monsters = []
      
      # Place stairs and monsters after ensuring player position
      place_stairs
      place_monsters
    end

    def self.random(player:, rows: nil, columns: nil)
      rows ||= rand(3..MAX_ROWS)
      columns ||= rand(3..MAX_COLUMNS)
      seed = rand(999_999_999_999_999)
      grid = Map.create(rows: rows, columns: columns, algorithm: Algorithms::BinaryTree, seed: seed)
      
      # Clear player's old position if needed
      if player.grid
        player.grid[player.row, player.column].tile = Vanilla::Support::TileType::FLOOR
      end
      
      # Update player's grid reference and position
      player.instance_variable_set(:@grid, grid)
      player.move_to(1, 1)
      
      new(grid: grid, player: player)
    end

    def place_monsters
      num_monsters = [(@grid.rows * @grid.columns) / 20, 1].max
      num_monsters.times do
        row = rand(0..@grid.rows - 1)
        column = rand(0..@grid.columns - 1)
        cell = @grid.cell_at(row, column)
        if cell.tile == Vanilla::Support::TileType::FLOOR && !cell.player?
          monster = Characters::Monster.new(row: row, column: column, grid: @grid)
          @monsters << monster
        end
      end
    end

    def place_stairs
      loop do
        row = rand(0..@grid.rows - 1)
        column = rand(0..@grid.columns - 1)
        cell = @grid.cell_at(row, column)
        if cell.tile == Vanilla::Support::TileType::FLOOR && !cell.player?
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
