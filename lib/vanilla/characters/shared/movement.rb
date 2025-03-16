module Vanilla
  module Characters
    module Shared
      module Movement
        def move(direction)
          case direction
          when :left
            move_left
          when :right
            move_right
          when :up
            move_up
          when :down
            move_down
          end
        end
  
        def move_left
          return unless can_move?(:west)
          update_position(:west)
        end
  
        def move_right
          return unless can_move?(:east)
          update_position(:east)
        end
  
        def move_up
          return unless can_move?(:north)
          update_position(:north)
        end
  
        def move_down
          return unless can_move?(:south)
          update_position(:south)
        end
  
        private
  
        def can_move?(direction)
          current_cell = grid[row, column]
          target_cell = current_cell.send(direction)
          
          # Can move if:
          # 1. Target cell exists
          # 2. Current cell is linked to target cell
          # 3. Target cell is not occupied by another unit
          target_cell && 
            current_cell.linked?(target_cell) && 
            !target_cell.occupied?
        end
  
        def update_position(direction)
          current_cell = grid[row, column]
          target_cell = current_cell.send(direction)
          
          # Update cell tiles
          current_cell.tile = Support::TileType::FLOOR
          target_cell.tile = self.tile
          
          # Update unit position
          case direction
          when :west
            self.column -= 1
          when :east
            self.column += 1
          when :north
            self.row -= 1
          when :south
            self.row += 1
          end
          
          # Check for stairs
          self.found_stairs = target_cell.tile == Support::TileType::STAIRS
        end
      end
    end
  end
end        
