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

  def self.play(rows: 10, columns: 10, png: false, display_distances: false, algorithm: Vanilla::BinaryTree, open_maze: [true, false].sample)
    grid = Vanilla::Map::Grid.new(rows: rows, columns: columns)

    algorithm.on(grid)
    grid.dead_ends

    self.display_distances(grid: grid) if display_distances

    puts Vanilla::Output::Terminal.new(grid, open_maze: open_maze)

    if png
      require_relative 'vanilla/output/png'
      Vanilla::Output::Png.new(grid).to_png
    end
  end

  # uses Dijkstra’s algorithm
  def self.display_distances(grid:)
    puts "displaying path distance from start to goal:"

    start_and_goal_points = [
      # top left
      # top right
      # bottom left
      # bottom right
      grid[0,0],
      grid[0, grid.columns - 1],
      grid[grid.rows - 1, 0],
      grid[grid.rows - 1, grid.columns - 1],

      # middle
      grid[(grid.rows - 1) / 2, (grid.columns - 1) / 2],
      grid[(grid.rows - 1) / 2, 0],
      grid[0, (grid.columns - 1) / 2],
    ]

    start, goal = start_and_goal_points.shuffle.shift(2)
    distances = start.distances

    puts "start: [#{start.row}, #{start.column}] goal: [#{goal.row}, #{goal.column}]"

    grid.distances = distances.path_to(goal)

    grid
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
