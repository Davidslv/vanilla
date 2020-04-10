module Vanilla
  module Algorithms
    class RecursiveBacktracker
      def self.on(grid)
        stack = []
        stack.push(grid.random_cell)

          while stack.any?
            current = stack.last
            neighbors = current.neighbors.select { |cell| cell.links.empty? }

            if neighbors.empty?
              stack.pop
            else
              neighbor = neighbors.sample
              current.link(cell: neighbor)
              stack.push(neighbor)
            end
          end

        grid
      end
    end
  end
end
