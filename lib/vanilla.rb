require 'pry'

module Vanilla
  require_relative 'vanilla/cell_distance'
  require_relative 'vanilla/binary_tree'

  require_relative 'vanilla/cell'
  require_relative 'vanilla/grid'
  require_relative 'vanilla/output/terminal'

  def self.play(rows: 10, columns: 10, png: false)
    grid = Vanilla::Grid.new(rows: rows, columns: columns)
    Vanilla::BinaryTree.on(grid)
    puts Vanilla::Output::Terminal.new(grid)

    if png
      require_relative 'vanilla/output/png'
      Vanilla::Output::Png.new(grid).to_png
    end
  end
end
