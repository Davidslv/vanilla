module Vanilla
  module Algorithms
    class BinaryTree < AbstractAlgorithm
      def self.on(grid)
        # The Binary Tree algorithm creates a perfect maze by:
        # 1. For each cell, considering only north and east neighbors
        # 2. Randomly linking to one of these neighbors if available
        # This creates a maze biased towards the north and east walls
        grid.each_cell do |cell|
          neighbors = []
          neighbors << cell.north if cell.north
          neighbors << cell.east if cell.east

          # Only link to one neighbor (north or east) to maintain walls
          if neighbors.any?
            neighbor = neighbors.sample
            cell.link(cell: neighbor)
            cell.tile = Vanilla::Support::TileType::FLOOR
            neighbor.tile = Vanilla::Support::TileType::FLOOR
          end
        end

        # Set walls for unlinked cells
        grid.set_walls
        grid
      end
    end
  end
end
