module Vanilla
  module Algorithms
    # PathFirst algorithm ensures there's always a valid path between any two points
    # by first creating a guaranteed path and then building the rest of the maze
    class PathFirst < AbstractAlgorithm
      def self.on(grid)
        # Initialize all cells as walls
        grid.each_cell do |cell|
          cell.tile = Support::TileType::WALL
        end

        # Start at (1,1)
        start_cell = grid.cell_at(1, 1)
        start_cell.tile = Support::TileType::FLOOR

        # Create a path to a random far point
        path = create_path_to_far_point(grid, start_cell)
        end_cell = path.last

        # Make sure the end point is a floor (not stairs - that's handled by Map)
        end_cell.tile = Support::TileType::FLOOR

        # Add some random connections to make it more maze-like
        add_random_connections(grid)

        grid
      end

      private

      def self.create_path_to_far_point(grid, start_cell)
        path = [start_cell]
        current = start_cell
        stack = []

        # Keep track of visited cells
        visited = { [current.row, current.col] => true }

        # Create a winding path
        loop do
          neighbors = unvisited_neighbors(grid, current, visited)
          
          if neighbors.empty?
            break if stack.empty?
            current = stack.pop
            next
          end

          # Choose a random neighbor
          next_cell = neighbors.sample
          next_cell.tile = Support::TileType::FLOOR
          visited[[next_cell.row, next_cell.col]] = true
          
          stack.push(current)
          path << next_cell
          current = next_cell

          # Stop if we've gone far enough (at least 5 steps away)
          break if path.length > 5 && rand < 0.2
        end

        path
      end

      def self.unvisited_neighbors(grid, cell, visited)
        neighbors = []
        
        [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |dr, dc|
          r, c = cell.row + dr, cell.col + dc
          next unless grid.valid_position?(r, c)
          
          neighbor = grid.cell_at(r, c)
          neighbors << neighbor unless visited[[r, c]]
        end

        neighbors
      end

      def self.add_random_connections(grid)
        # Add some random additional paths
        grid.each_cell do |cell|
          next if cell.tile == Support::TileType::WALL
          
          [[0, 1], [1, 0]].each do |dr, dc|
            r, c = cell.row + dr, cell.col + dc
            next unless grid.valid_position?(r, c)
            
            neighbor = grid.cell_at(r, c)
            if neighbor.tile == Support::TileType::WALL && rand < 0.3
              neighbor.tile = Support::TileType::FLOOR
            end
          end
        end
      end
    end
  end
end 