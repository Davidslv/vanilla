module Vanilla
  class BinaryTree
    def self.on(grid)
      grid.each_cell do |cell|
        neighbors = []
        neighbors << cell.north if cell.north
        neighbors << cell.east if cell.east
        neighbor = neighbors.sample

        cell.link(cell: neighbor) if neighbor
      end

      grid
    end
  end
end
