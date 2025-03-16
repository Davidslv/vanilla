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
        move(-1, 0)
      when 'j', 's'
        move(0, 1)
      when 'k', 'w'
        move(0, -1)
      when 'l', 'd'
        move(1, 0)
      when "\C-c", "q"
        exit
      else
        add_message("Invalid command: #{key}")
      end
    end

    private

    def move(dx, dy)
      new_row = player.row + dy
      new_col = player.column + dx
      target_cell = player.grid[new_row, new_col]

      return add_message("You hit a wall!") unless target_cell && target_cell.tile != Vanilla::Support::TileType::WALL

      case target_cell.tile
      when Vanilla::Support::TileType::FLOOR
        player.move_to(new_row, new_col)
        add_message("You move #{direction_name(dx, dy)}")
      when Vanilla::Support::TileType::MONSTER
        monster = player.grid.monsters.find { |m| m.row == new_row && m.column == new_col }
        if monster
          initiate_combat(monster)
        else
          target_cell.tile = Vanilla::Support::TileType::FLOOR
          player.move_to(new_row, new_col)
          add_message("The corridor ahead is clear.")
        end
      when Vanilla::Support::TileType::STAIRS
        player.move_to(new_row, new_col)
        player.found_stairs = true
        add_message("You found the stairs!")
      else
        add_message("You can't move there!")
      end
    end

    def direction_name(dx, dy)
      case [dx, dy]
      when [-1, 0] then "west"
      when [1, 0] then "east"
      when [0, -1] then "north"
      when [0, 1] then "south"
      end
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
