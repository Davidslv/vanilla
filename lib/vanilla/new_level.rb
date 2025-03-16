module Vanilla
  class NewLevel
    attr_reader :grid, :player, :monsters, :terminal

    def initialize(seed: nil, rows: 10, columns: 10, player: nil)
      @grid = Vanilla::Map.create(rows: rows, columns: columns, algorithm: Vanilla::Algorithms::AVAILABLE.sample, seed: seed)
      @monsters = []
      
      start = start_position(grid: grid)
      positions = longest_path(grid: grid, start: start)

      player_position, stairs_position = positions[:start], positions[:goal]

      player_row = player_position[0]
      player_column = player_position[1]
      stairs_row = stairs_position[0]
      stairs_column = stairs_position[1]

      @player = player || Characters::Player.new(row: player_row, column: player_column)
      @player.row = player_row
      @player.column = player_column

      @terminal = Output::Terminal.new(@grid, player: @player)

      Vanilla::Draw.player(grid: grid, unit: @player, terminal: terminal)
      Vanilla::Draw.stairs(grid: grid, row: stairs_row, column: stairs_column, terminal: terminal)
      
      place_monsters
    end

    def self.random(player: nil)
      rows = rand(8..20)
      columns = rand(8..20)

      new(rows: rows, columns: columns, player: player)
    end

    private

    def start_position(grid:)
      grid[rand(0..((grid.rows - 1) / 2)), rand(0..((grid.columns - 1) / 2))]
    end

    def longest_path(grid:, start:)
      distances = start.distances
      new_start, distance = distances.max

      new_distances = new_start.distances
      goal, distances = new_distances.max

      {
        start: [new_start.row, new_start.column],
        goal: [goal.row, goal.column]
      }
    end

    def place_monsters
      # Place 2-4 monsters on the level
      num_monsters = rand(2..4)
      
      num_monsters.times do
        # Find a random floor tile that's not occupied
        row = rand(0...grid.rows)
        column = rand(0...grid.columns)
        
        # Skip if the tile is not a floor or is occupied
        next unless grid[row, column].tile == Support::TileType::FLOOR
        next if [row, column] == [player.row, player.column]
        next if monsters.any? { |m| m.row == row && m.column == column }
        
        monster = Characters::Monster.new(
          name: "Monster #{monsters.size + 1}",
          row: row,
          column: column,
          health: 20 + (player.level * 5),
          attack: 5 + (player.level * 2),
          defense: 2 + player.level,
          experience_value: 10 + (player.level * 5)
        )
        
        monsters << monster
        grid.monsters << monster
        
        # Set the cell's tile to monster
        grid[row, column].tile = Support::TileType::MONSTER
      end

      # Draw all monsters on the map
      monsters.each do |monster|
        Vanilla::Draw.monster(grid: grid, unit: monster, terminal: terminal)
      end
    end
  end
end
