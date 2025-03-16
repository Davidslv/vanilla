module Vanilla
  module Draw
    def self.map(grid, open_maze: true, terminal: nil)
      system("clear")
      string = "Seed: #{$seed} | Rows: #{grid.rows} | Columns: #{grid.columns}"
      puts string
      puts(("-" * string.size) + "\n\n")

      if terminal
        puts terminal
      else
        puts Vanilla::Output::Terminal.new(grid, open_maze: open_maze)
      end
    end

    def self.tile(grid:, row:, column:, tile:, terminal: nil)
      raise ArgumentError, 'Invalid tile type' unless Support::TileType::VALUES.include?(tile)

      cell = grid[row, column]
      cell.tile = tile

      self.map(grid, terminal: terminal)
    end

    def self.player(grid:, unit:, terminal: nil)
      self.tile(grid: grid, row: unit.row, column: unit.column, tile: unit.tile, terminal: terminal)
    end

    def self.monster(grid:, unit:, terminal: nil)
      self.tile(grid: grid, row: unit.row, column: unit.column, tile: unit.tile, terminal: terminal)
    end

    def self.stairs(grid:, row:, column:, terminal: nil)
      self.tile(grid: grid, row: row, column: column, tile: Vanilla::Support::TileType::STAIRS, terminal: terminal)
    end

    def self.movement(grid:, unit:, direction:, terminal: nil)
      Vanilla::Movement.move(grid: grid, unit: unit, direction: direction)

      self.map(grid, terminal: terminal)
    end
  end
end
