require_relative 'base_command'
require_relative '../components/transform_component'
require_relative '../components/movement_component'
require_relative '../support/tile_type'

module Vanilla
  module Commands
    class MovementCommand < BaseCommand
      attr_reader :direction

      def initialize(world:, entity:, direction:)
        super(world: world, entity: entity)
        @direction = direction
      end

      def can_execute?
        transform = get_component(Components::TransformComponent)
        return false unless transform

        new_row, new_col = calculate_new_position(transform)
        return false unless valid_position?(new_row, new_col)

        current_cell = transform.grid.cell_at(transform.position[0], transform.position[1])
        target_cell = transform.grid.cell_at(new_row, new_col)
        
        # Check if cells are linked (there's a passage between them)
        return false unless current_cell.linked?(target_cell)

        # Check if target cell is walkable
        case target_cell.tile
        when Support::TileType::FLOOR, Support::TileType::STAIRS
          true
        when Support::TileType::MONSTER
          # Allow movement to monster cells (will trigger combat)
          true
        else
          false
        end
      end

      def execute
        return false unless can_execute?

        transform = get_component(Components::TransformComponent)
        new_row, new_col = calculate_new_position(transform)
        target_cell = transform.grid.cell_at(new_row, new_col)

        case target_cell.tile
        when Support::TileType::MONSTER
          emit_event(:combat_initiated, target: target_cell.content)
          false # Movement doesn't complete when initiating combat
        when Support::TileType::STAIRS
          transform.move_to(new_row, new_col)
          emit_event(:stairs_found)
          true
        else
          transform.move_to(new_row, new_col)
          emit_event(:movement_completed, from: transform.position, to: [new_row, new_col])
          true
        end
      end

      private

      def calculate_new_position(transform)
        current_row, current_col = transform.position
        
        case direction
        when :left then [current_row, current_col - 1]
        when :right then [current_row, current_col + 1]
        when :up then [current_row - 1, current_col]
        when :down then [current_row + 1, current_col]
        end
      end

      def valid_position?(row, col)
        transform = get_component(Components::TransformComponent)
        grid = transform.grid
        row >= 0 && col >= 0 && row < grid.rows && col < grid.columns
      end
    end
  end
end 