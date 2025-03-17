module Vanilla
  class Level
    require_relative 'support/tile_type'
    require_relative 'components/transform_component'
    attr_reader :grid, :player, :monsters, :terminal

    MAX_ROWS = 10
    MAX_COLUMNS = 10
    MIN_ROWS = 5  # Ensure minimum size for gameplay
    MIN_COLUMNS = 5

    def initialize(grid:, player:, terminal: nil)
      @grid = grid
      @player = player
      @terminal = terminal || Output::Terminal.new(grid: grid, player: @player)
      @monsters = []
      
      # Place stairs and monsters after initialization
      place_stairs
      place_monsters
    end

    def self.random(player:, rows: nil, columns: nil)
      # Ensure minimum dimensions
      rows = [rows || MIN_ROWS, MIN_ROWS].max
      columns = [columns || MIN_COLUMNS, MIN_COLUMNS].max
      
      seed = rand(999_999_999_999_999)
      
      # Create new grid
      grid = Map.create(
        rows: rows,
        columns: columns,
        algorithm: Algorithms::BinaryTree,
        seed: seed
      )
      
      # Create new level instance
      level = new(grid: grid, player: player)
      
      # Find a valid starting position (first available floor tile)
      starting_cell = find_floor_tile(grid)
      
      # Ensure we have a valid starting position
      unless starting_cell
        # If no floor tile found, make position (1,1) a floor tile
        starting_cell = grid.cell_at(1, 1)
        starting_cell.tile = Support::TileType::FLOOR
      end
      
      # Get the player's transform component and update its position
      transform = player.get_component(Components::TransformComponent)
      transform.update_grid(grid)
      transform.move_to(starting_cell.row, starting_cell.column)
      
      level
    end

    def place_monsters
      num_monsters = [(@grid.rows * @grid.columns) / 20, 1].max
      placed_monsters = 0
      max_attempts = num_monsters * 10  # Allow multiple attempts per monster
      attempts = 0
      
      while placed_monsters < num_monsters && attempts < max_attempts
        attempts += 1
        
        row = rand(0..@grid.rows - 1)
        column = rand(0..@grid.columns - 1)
        cell = @grid.cell_at(row, column)
        
        # Only place monster on empty floor tiles away from player
        if cell && 
           cell.tile == Support::TileType::FLOOR && 
           !cell.content &&
           !adjacent_to_player?(row, column)
          monster = Characters::Monster.new(grid: @grid, row: row, column: column)
          @monsters << monster
          placed_monsters += 1
        end
      end
    end

    def place_stairs
      max_attempts = @grid.rows * @grid.columns  # Try every position if needed
      attempts = 0
      
      loop do
        break if attempts >= max_attempts
        attempts += 1
        
        row = rand(0..@grid.rows - 1)
        column = rand(0..@grid.columns - 1)
        cell = @grid.cell_at(row, column)
        
        # Only place stairs on empty floor tiles away from player
        if cell && 
           cell.tile == Support::TileType::FLOOR && 
           !cell.content &&
           !adjacent_to_player?(row, column)
          cell.tile = Support::TileType::STAIRS
          return true  # Successfully placed stairs
        end
      end
      
      # If we couldn't place stairs normally, force-create a floor tile and place stairs
      empty_cells = find_empty_cells
      if empty_cell = empty_cells.first
        empty_cell.tile = Support::TileType::FLOOR
        empty_cell.tile = Support::TileType::STAIRS
        return true
      end
      
      false  # Failed to place stairs
    end

    # Updates the terminal display
    def update
      @terminal.clear
      @terminal.write
    end

    private

    def self.count_floor_tiles(grid)
      count = 0
      grid.each_cell do |cell|
        count += 1 if cell.tile == Support::TileType::FLOOR
      end
      count
    end

    def self.find_floor_tile(grid)
      grid.each_cell do |cell|
        return cell if cell.tile == Support::TileType::FLOOR && !cell.content
      end
      nil
    end

    def find_empty_cells
      empty_cells = []
      @grid.each_cell do |cell|
        if !cell.content && cell.tile != Support::TileType::STAIRS
          empty_cells << cell
        end
      end
      empty_cells
    end

    def adjacent_to_player?(row, column)
      player_transform = @player.get_component(Components::TransformComponent)
      player_row, player_col = player_transform.position
      
      (row - player_row).abs <= 1 && (column - player_col).abs <= 1
    end
  end
end

