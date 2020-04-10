require 'pry'

module Vanilla
  require_relative 'vanilla/map/distance_between_cells'
  require_relative 'vanilla/map/cell'
  require_relative 'vanilla/map/grid'
  require_relative 'vanilla/output/terminal'

  # algorithms
  require_relative 'vanilla/binary_tree'
  require_relative 'vanilla/aldous_broder'
  require_relative 'vanilla/recursive_backtracker'
  require_relative 'vanilla/recursive_division'

  def self.play(rows: 10, columns: 10, png: false, algorithm: Vanilla::BinaryTree, open_maze: [true, false].sample)
    grid = Vanilla::Map::Grid.new(rows: rows, columns: columns)

    algorithm.on(grid)
    grid.dead_ends

    puts Vanilla::Output::Terminal.new(grid, open_maze: open_maze)

    if png
      require_relative 'vanilla/output/png'
      Vanilla::Output::Png.new(grid).to_png
    end
  end

  # uses Dijkstra’s algorithm
  def self.display_distances(rows: 10, columns: 10)
    # TODO:
    # - provide a start point
    # - provide a goal point

    grid = Vanilla::Map::Grid.new(rows: rows, columns: columns)
    Vanilla::BinaryTree.on(grid)

    start = grid[0, 0]
    goals = [
      grid[grid.rows - 1, 0],
      grid[grid.rows / 2, grid.columns / 2],
    ]
    number = rand(0..goals.size - 1)
    goal = goals[number]
    puts number
    distances = start.distances

    puts "path from northwest corner to southwest corner:"
    grid.distances = distances.path_to(goal)

    puts Vanilla::Output::Terminal.new(grid)
    Vanilla::Output::Png.new(grid, start: start, goal: goal).to_png if false

    sleep 0.4
  end

  def self.longest_path(rows: 10, columns: 10)
    grid = Vanilla::Map::Grid.new(rows: rows, columns: columns)
    Vanilla::BinaryTree.on(grid)

    start = grid[0,0]

    distances = start.distances
    new_start, distance = distances.max

    new_distances = new_start.distances
    goal, distances = new_distances.max

    grid.distances = new_distances.path_to(goal)

    puts Vanilla::Output::Terminal.new(grid)
  end
end
