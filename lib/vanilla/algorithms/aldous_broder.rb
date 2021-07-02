module Vanilla
  module Algorithms
    class AldousBroder < AbstractAlgorithm
      def self.on(grid)
        cell = grid.random_cell
        unvisited = grid.size - 1

          while unvisited > 0
            neighbor = cell.neighbors.sample

            if neighbor.links.empty?
              cell.link(cell: neighbor)
              unvisited -= 1
            end

            cell = neighbor
          end

        grid
      end
    end
  end
end
