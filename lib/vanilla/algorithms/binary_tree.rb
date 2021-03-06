module Vanilla
  module Algorithms
    class BinaryTree < AbstractAlgorithm
      def self.on(grid)
        # What the binary tree is doing here is linking each cell that has been created before.
        # This will be necessary to decide on the maze layout later on.
        # Linked neighbors means that theres a passage between both cells (no wall)
        grid.each_cell do |cell|
          neighbors = []
          neighbors << cell.north if cell.north
          neighbors << cell.east if cell.east

          index = rand(neighbors.size)
          neighbor = neighbors[index]

          cell.link(cell: neighbor) if neighbor
        end

        grid
      end
    end
  end
end
