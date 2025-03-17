module Vanilla
  class Command
    require_relative 'support/tile_type'
    require_relative 'components/movement_component'
    require_relative 'components/transform_component'
    require_relative 'components/combat_component'
    require_relative 'level'

    attr_reader :player, :terminal, :messages, :grid

    def initialize(player:, terminal:)
      @player = player
      @terminal = terminal
      @grid = player.grid
      @messages = []
      @transform = player.get_component(Components::TransformComponent)
      @combat = player.get_component(Components::CombatComponent)
    end

    def self.process(key:, grid:, player:, terminal:)
      new(player: player, terminal: terminal).process(key)
    end

    def process(key)
      case key
      when 'h'
        handle_movement(:left)
      when 'j'
        handle_movement(:down)
      when 'k'
        handle_movement(:up)
      when 'l'
        handle_movement(:right)
      when "\C-c", "q"
        exit
      else
        add_message("Invalid command: #{key}")
      end
    end

    private

    def handle_movement(direction)
      messages = []
      new_row, new_col = calculate_new_position(direction)
      
      return add_message("Can't move there!") unless valid_position?(new_row, new_col)

      current_cell = @grid.cell_at(@transform.position[0], @transform.position[1])
      target_cell = @grid.cell_at(new_row, new_col)
      
      # Check if cells are linked (there's a passage between them)
      unless current_cell.linked?(target_cell)
        add_message("You hit a wall!")
        return
      end
      
      case target_cell.tile
      when Support::TileType::MONSTER
        messages.concat(handle_combat(target_cell.content))
      when Support::TileType::STAIRS
        messages.concat(handle_stairs(new_row, new_col))
      when Support::TileType::FLOOR
        @transform.move_to(new_row, new_col)
        messages << "You move to #{new_row},#{new_col}"
      else
        messages << "You can't move there!"
      end

      messages.each { |msg| add_message(msg) }
      messages
    end

    def handle_stairs(new_row, new_col)
      messages = []
      messages << "You found stairs leading to another level!"
      messages << "Descending to the next level..."

      # Move to stairs first (this ensures we're in a valid position before transition)
      @transform.move_to(new_row, new_col)
      
      # Set the found_stairs flag to trigger level change
      @player.found_stairs = true
      
      messages
    end

    def handle_combat(monster)
      return ["No monster to fight!"] unless monster

      if @combat.attack(monster)
        messages = @combat.messages.dup
        @combat.messages.clear

        # If monster was defeated, update the cell
        monster_stats = monster.get_component(Components::StatsComponent)
        if !monster_stats.alive?
          monster_transform = monster.get_component(Components::TransformComponent)
          row, col = monster_transform.position
          @grid.cell_at(row, col).tile = Support::TileType::FLOOR
          @grid.cell_at(row, col).content = nil
        end

        messages
      else
        ["Combat failed!"]
      end
    end

    def calculate_new_position(direction)
      current_row, current_col = @transform.position
      
      case direction
      when :left then [current_row, current_col - 1]
      when :right then [current_row, current_col + 1]
      when :up then [current_row - 1, current_col]
      when :down then [current_row + 1, current_col]
      end
    end

    def valid_position?(row, col)
      row >= 0 && col >= 0 && row < @grid.rows && col < @grid.columns
    end

    def add_message(message)
      @messages << message
      @terminal.add_message(message)
    end
  end
end
