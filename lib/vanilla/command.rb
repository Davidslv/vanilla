module Vanilla
  class Command
    def initialize(key:, grid:, unit:, terminal:)
      @key = key
      @grid, @unit = grid, unit
      @terminal = terminal
    end

    def self.process(key:, grid:, unit:, terminal:)
      new(key: key, grid: grid, unit: unit, terminal: terminal).process
    end

    def process
      case key
      when "k", "K", :KEY_UP
        handle_movement(:up)
      when "j", "J", :KEY_DOWN
        handle_movement(:down)
      when "l", "L", :KEY_RIGHT
        handle_movement(:right)
      when "h", "H", :KEY_LEFT
        handle_movement(:left)
      when "\C-c", "q"
        exit
      end
    end

    private

    attr_reader :key, :grid, :unit, :terminal

    def handle_movement(direction)
      # Store current position
      old_row, old_column = unit.row, unit.column
      
      # Attempt movement
      Vanilla::Draw.movement(grid: grid, unit: unit, direction: direction, terminal: terminal)
      
      # Check if we moved into a monster's space
      if grid.monsters&.any? { |m| m.row == unit.row && m.column == unit.column }
        monster = grid.monsters.find { |m| m.row == unit.row && m.column == unit.column }
        initiate_combat(monster)
        
        # If monster is still alive, move player back
        if monster.alive?
          unit.row, unit.column = old_row, old_column
          Vanilla::Draw.player(grid: grid, unit: unit, terminal: terminal)
        end
      end
    end

    def initiate_combat(monster)
      # Display initial combat messages
      terminal.add_message("Combat initiated with #{monster.name}!")
      terminal.add_message("Monster HP: #{monster.health}/#{monster.max_health}")
      terminal.add_message("Your HP: #{unit.health}/#{unit.max_health}")
      
      # Force display update
      Vanilla::Draw.map(grid, terminal: terminal)
      sleep(1) # Give player time to read initial messages
      
      while monster.alive? && unit.alive?
        # Player's turn
        damage = unit.attack_target(monster)
        terminal.add_message("You deal #{damage} damage to #{monster.name}!")
        terminal.add_message("Monster HP: #{monster.health}/#{monster.max_health}")
        Vanilla::Draw.map(grid, terminal: terminal)
        sleep(1)
        
        break unless monster.alive?
        
        # Monster's turn
        damage = monster.attack_target(unit)
        terminal.add_message("#{monster.name} deals #{damage} damage to you!")
        terminal.add_message("Your HP: #{unit.health}/#{unit.max_health}")
        Vanilla::Draw.map(grid, terminal: terminal)
        sleep(1)
      end
      
      if monster.alive?
        terminal.add_message("You lost the battle!")
        terminal.add_message("Game Over!")
        terminal.add_message("Would you like to start a new game? (y/n)")
        Vanilla::Draw.map(grid, terminal: terminal)
        response = STDIN.getch.downcase
        if response == 'y'
          terminal.add_message("Starting new game...")
          Vanilla.run
        else
          terminal.add_message("Good bye!")
          exit
        end
      else
        terminal.add_message("You won the battle!")
        unit.gain_experience(monster.experience_value)
        grid.monsters.delete(monster)
        Vanilla::Draw.tile(grid: grid, row: monster.row, column: monster.column, tile: Support::TileType::FLOOR, terminal: terminal)
      end
      
      terminal.add_message("Press any key to continue...")
      Vanilla::Draw.map(grid, terminal: terminal)
      STDIN.getch
      
      # Clear messages after battle is resolved
      terminal.clear_messages
      Vanilla::Draw.map(grid, terminal: terminal)
    end
  end
end
