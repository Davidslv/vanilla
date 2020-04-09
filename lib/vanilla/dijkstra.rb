require_relative 'output/png'
require_relative 'output/terminal'
require_relative 'cell_distance'
require_relative 'distance_grid'
require_relative 'binary_tree'

# ruby -I. ./lib/vanilla/dijkstra.rb

2.times do
  grid = Vanilla::DistanceGrid.new(rows: 10, columns: 10)
  Vanilla::BinaryTree.on(grid)

  start = grid[0, 0]
  goal = grid[grid.rows - 1, 0]
  distances = start.distances

  puts "path from northwest corner to southwest corner:"
  grid.distances = distances.path_to(goal)

  puts Vanilla::Output::Terminal.new(grid)
  Vanilla::Output::Png.new(grid, start: start, goal: goal).to_png if false # turn off

  sleep 0.4
end
