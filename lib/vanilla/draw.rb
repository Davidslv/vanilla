module Vanilla
  module Draw
    def self.map(grid, open_maze: true)
      system("clear")
      string = "Seed: #{$seed} | Rows: #{grid.rows} | Columns: #{grid.columns}"
      puts string
      puts(("-" * string.size) + "\n\n")

      puts Vanilla::Output::Terminal.new(grid, open_maze: open_maze)
    end

    def self.tile(grid:, row:, column:, tile:)
      raise ArgumentError, 'Invalid tile type' unless Support::TileType::VALUES.include?(tile)

      cell = grid[row, column]
      cell.tile = tile

      self.map(grid)
    end

    def self.player(grid:, unit:)
      self.tile(grid: grid, row: unit.row, column: unit.column, tile: unit.tile)
    end

    def self.stairs(grid:, row:, column:)
      self.tile(grid: grid, row: row, column: column, tile: Vanilla::Support::TileType::STAIRS)
    end

    def self.movement(grid:, unit:, direction:)
      Vanilla::Movement.move(grid: grid, unit: unit, direction: direction)

      self.map(grid)
    end
  end
end
