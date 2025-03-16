module Vanilla
  class Command
    require_relative 'support/tile_type'
    attr_reader :player, :terminal, :messages

    def initialize(player:, terminal:)
      @player = player
      @terminal = terminal
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
      result = Movement.move(grid: player.grid, unit: player, direction: direction)
      
      if result
        handle_cell_interaction(player.grid[player.row, player.column])
        add_message("You move #{direction_name(direction)}")
      else
        add_message("You hit a wall!")
      end
    end

    def handle_cell_interaction(cell)
      if cell.monster?
        monster = player.grid.monsters.find { |m| m.row == cell.row && m.column == cell.column }
        initiate_combat(monster) if monster
      elsif cell.stairs?
        player.found_stairs = true
        add_message("You found the stairs!")
      end
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
        player.grid.monsters.delete(monster)
        # Clear the monster's tile after it's defeated
        player.grid[monster.row, monster.column].tile = Vanilla::Support::TileType::FLOOR
      end
    end

    def add_message(message)
      @messages << message
      @terminal.add_message(message)
    end
  end
end
