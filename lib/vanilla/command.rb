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
        move_direction(:left)
      when 'j', 's'
        move_direction(:down)
      when 'k', 'w'
        move_direction(:up)
      when 'l', 'd'
        move_direction(:right)
      when "\C-c", "q"
        exit
      else
        add_message("Invalid command: #{key}")
      end
    end

    private

    def move_direction(direction)
      current_cell = player.grid[player.row, player.column]
      target_cell = case direction
                   when :left then current_cell.west
                   when :right then current_cell.east
                   when :up then current_cell.north
                   when :down then current_cell.south
                   end

      return add_message("You hit a wall!") unless target_cell && current_cell.linked?(target_cell)

      case target_cell.tile
      when Vanilla::Support::TileType::MONSTER
        monster = player.grid.monsters.find { |m| m.row == target_cell.row && m.column == target_cell.column }
        if monster
          initiate_combat(monster)
        else
          target_cell.tile = Vanilla::Support::TileType::FLOOR
          player.move_to(target_cell.row, target_cell.column)
          add_message("The corridor ahead is clear.")
        end
      when Vanilla::Support::TileType::STAIRS
        player.move_to(target_cell.row, target_cell.column)
        player.found_stairs = true
        add_message("You found the stairs!")
      else
        if target_cell.tile == Vanilla::Support::TileType::WALL
          add_message("You hit a wall!")
        else
          player.move_to(target_cell.row, target_cell.column)
          add_message("You move #{direction_name(direction)}")
        end
      end
    end

    def direction_name(direction)
      case direction
      when :left then "west"
      when :right then "east"
      when :up then "north"
      when :down then "south"
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
