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
  
          self.found_stairs = stairs?(:west)
          update_position(:west)
        end
  
        def move_right
          return unless can_move?(:east)
  
          self.found_stairs = stairs?(:east)
          update_position(:east)
        end
  
        def move_up
          return unless can_move?(:north)
  
          self.found_stairs = stairs?(:north)
          update_position(:north)
        end
  
        def move_down
          return unless can_move?(:south)
  
          self.found_stairs = stairs?(:south)
          update_position(:south)
        end
  
        private
  
        def can_move?(direction)
          # This method should be implemented in the including class
          # to check if the move is possible based on the game's rules
          raise NotImplementedError, "#{self.class} must implement #can_move?"
        end
  
        def stairs?(direction)
          # This method should be implemented in the including class
          # to check if there are stairs in the given direction
          raise NotImplementedError, "#{self.class} must implement #stairs?"
        end
  
        def update_position(direction)
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
        end
      end
    end
  end
end        
