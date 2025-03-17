require_relative 'base_command'
require_relative '../components/transform_component'
require_relative '../components/movement_component'
require_relative '../support/tile_type'
require_relative '../map_utils/grid'
require_relative '../events/event_manager'
require_relative '../map'
require_relative '../algorithms'

module Vanilla
  module Commands
    # Command that handles entity movement
    class MovementCommand < BaseCommand
      # Initialize a new movement command
      #
      # @param world [World] The game world
      # @param entity [Entity] The entity to move
      # @param direction [Array<Integer>] The direction to move as [row_delta, col_delta]
      def initialize(world, entity, direction)
        super(world, entity)
        @direction = direction
      end

      # Execute the movement
      #
      # @return [Boolean] true if movement was successful
      def execute
        transform = entity.get_component(Components::TransformComponent)
        return false unless transform

        target_row = transform.position[0] + @direction[0]
        target_col = transform.position[1] + @direction[1]

        puts "\nMovementCommand debug:"
        puts "Current position: #{transform.position.inspect}"
        puts "Direction: #{@direction.inspect}"
        puts "Target position: [#{target_row}, #{target_col}]"

        target_cell = transform.grid.cell_at(target_row, target_col)
        return false unless target_cell

        puts "Target cell tile: #{target_cell.tile}"

        # Check if moving to stairs
        if target_cell.tile == Support::TileType::STAIRS
          puts "Moving to stairs..."
          # First move to the stairs position
          transform.move_to(target_row, target_col)
          puts "After move_to:"
          puts "Player position: #{transform.position.inspect}"
          puts "Current cell tile: #{transform.current_cell.tile}"
          
          # Create a new map for the next level
          map = Map.new(rows: transform.grid.rows, cols: transform.grid.cols, algorithm: Algorithms::BinaryTree)
          new_grid = map.create
          
          # Ensure the starting position is a floor tile
          start_cell = new_grid.cell_at(1, 1)
          start_cell.tile = Support::TileType::FLOOR
          
          # Update player's grid and position
          transform.update_grid(new_grid)
          transform.move_to(1, 1) # Place player in a safe starting position
          
          # Emit level transition event
          world.event_manager.trigger(:level_transition, {
            old_grid: transform.grid,
            new_grid: new_grid,
            entity: entity
          })
          
          return true
        end

        # Handle normal movement
        if target_cell.tile == Support::TileType::FLOOR
          transform.move_to(target_row, target_col)
          return true
        end

        false
      end

      private

      def calculate_target_position(transform)
        [
          transform.position[0] + @direction[0],
          transform.position[1] + @direction[1]
        ]
      end

      def handle_monster_collision(target_cell)
        return false unless target_cell.content.is_a?(Entities::Monster)
        # Handle monster collision logic here
        true
      end
    end
  end
end 