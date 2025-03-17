module Vanilla
  module Algorithms
    class BinaryTree < AbstractAlgorithm
      def self.on(grid)
        # The Binary Tree algorithm creates a perfect maze by:
        # 1. For each cell, considering only north and east neighbors
        # 2. Randomly linking to one of these neighbors if available
        # This creates a maze biased towards the north and east walls
        
        # First, set all cells to walls
        grid.each_cell do |cell|
          cell.tile = Vanilla::Support::TileType::WALL
        end
        
        # Then carve passages
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

        # Ensure the starting position (1,1) is accessible
        start_cell = grid.cell_at(1, 1)
        if start_cell
          start_cell.tile = Vanilla::Support::TileType::FLOOR
          
          # If start cell has no links, link it to a neighbor
          if start_cell.links.empty?
            if start_cell.east
              start_cell.link(cell: start_cell.east)
              start_cell.east.tile = Vanilla::Support::TileType::FLOOR
            elsif start_cell.south
              start_cell.link(cell: start_cell.south)
              start_cell.south.tile = Vanilla::Support::TileType::FLOOR
            end
          end
        end

        grid
      end
    end
  end
end
