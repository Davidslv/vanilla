module Vanilla
  class Command
    require_relative 'support/tile_type'
    require_relative 'components/movement_component'
    require_relative 'level'
    attr_reader :player, :terminal, :messages, :grid

    def initialize(player:, terminal:)
      @player = player
      @terminal = terminal
      @grid = player.grid
      @messages = []
    end

    def self.process(key:, grid:, player:, terminal:)
      new(player: player, terminal: terminal).process(key)
    end

    def process(key)
      case key
      when 'h', 'a'
        handle_movement(:left)
      when 'j', 's'
        handle_movement(:down)
      when 'k', 'w'
        handle_movement(:up)
      when 'l', 'd'
        handle_movement(:right)
      when "\C-c", "q"
        exit
      else
        add_message("Invalid command: #{key}")
      end
    end

    private

    def handle_movement(direction)
      movement = player.get_component(Components::MovementComponent)
      transform = player.get_component(Components::TransformComponent)
      
      # Get the target cell before moving
      current_cell = grid.cell_at(transform.row, transform.column)
      target_cell = case direction
        when :left
          current_cell.west
        when :right
          current_cell.east
        when :up
          current_cell.north
        when :down
          current_cell.south
      end
      
      # Store the target cell's original tile
      target_tile = target_cell&.tile
      
      # Attempt to move
      result = movement.move(direction)
      
      if result
        add_message("You move #{direction_name(direction)}")
        # Check the original tile of the cell we moved to
        if target_tile == Vanilla::Support::TileType::STAIRS
          add_message("You found the stairs!")
          add_message("Descending to the next level...")
          
          # Create new level and update references
          @level = Level.random(player: player)
          @grid = @level.grid
          @terminal.grid = @grid
          
          # Update the player's grid reference
          transform.update_grid(@grid)
          
          add_message("You find yourself in a new area!")
        elsif target_cell.monster?
          monster = grid.monsters.find { |m| m.row == target_cell.row && m.column == target_cell.column }
          initiate_combat(monster) if monster
        end
      else
        add_message("You hit a wall!")
      end
    end

    def handle_cell_interaction(cell)
      # Debug: Print cell information
      add_message("DEBUG: Cell tile is: #{cell.tile.inspect}")
      add_message("DEBUG: Is stairs? #{cell.stairs?}")
      
      if cell.monster?
        monster = grid.monsters.find { |m| m.row == cell.row && m.column == cell.column }
        initiate_combat(monster) if monster
      elsif cell.stairs?
        # Immediately generate new level when player moves onto stairs
        add_message("You found the stairs!")
        add_message("Descending to the next level...")
        
        # Create new level and update references
        @level = Level.random(player: player)
        @grid = @level.grid
        @terminal.grid = @grid
        
        # Update the player's grid reference
        movement = player.get_component(Components::MovementComponent)
        transform = player.get_component(Components::TransformComponent)
        transform.update_grid(@grid)
        
        add_message("You find yourself in a new area!")
      end
    end

    def progress_to_next_level
      add_message("Descending to the next level...")
      
      # Clear the stairs tile before transitioning
      current_cell = grid.cell_at(player.row, player.column)
      current_cell.tile = Vanilla::Support::TileType::FLOOR
      
      # Create new level and update references
      @level = Level.random(player: player)
      @grid = @level.grid
      @terminal.grid = @grid
      
      # Reset player's stairs flag
      player.found_stairs = false
      
      add_message("You find yourself in a new area!")
    end

    def direction_name(direction)
      direction.to_s
    end

    def initiate_combat(monster)
      add_message("You encounter a #{monster.name}!")
      add_message("The #{monster.name} growls menacingly.")
      
      while monster.alive? && player.alive?
        combat_round(monster)
        break unless monster.alive? && player.alive?
      end

      if !player.alive?
        add_message("You have been defeated!")
        exit
      end
    end

    def combat_round(monster)
      # Player's turn
      damage_dealt = player.attack_target(monster)
      add_message("You strike the #{monster.name} for #{damage_dealt} damage!")
      add_message("The #{monster.name} has #{monster.health} HP remaining.")

      return unless monster.alive?

      # Monster's turn
      damage_taken = monster.attack_target(player)
      add_message("The #{monster.name} retaliates for #{damage_taken} damage!")
      add_message("You have #{player.health} HP remaining.")

      if !monster.alive?
        add_message("The #{monster.name} falls to the ground, defeated!")
        add_message("You gain #{monster.experience_value} experience points!")
        player.gain_experience(monster.experience_value)
        grid.monsters.delete(monster)
        # Clear the monster's tile after it's defeated
        grid.cell_at(monster.row, monster.column).tile = Vanilla::Support::TileType::FLOOR
      end
    end

    def add_message(message)
      @messages << message
      @terminal.add_message(message)
    end
  end
end
