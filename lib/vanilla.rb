require 'pry'

module Vanilla
  # map
  require_relative 'vanilla/map'

  # output
  require_relative 'vanilla/output/terminal'

  # algorithms
  require_relative 'vanilla/algorithms'

  def self.play(rows: 10, columns: 10, png: false, display_distances: false, display_longest: false, algorithm: Vanilla::Algorithms::BinaryTree, open_maze: [true, false].sample)
    grid = Vanilla::Map::Grid.new(rows: rows, columns: columns)

    algorithm.on(grid)
    grid.dead_ends

    start, goal = self.start_and_goal_points(grid: grid) if display_distances || display_longest
    self.display_distances(grid: grid, start: start, goal: goal) if (display_distances && !display_longest)
    self.longest_path(grid: grid , start: start) if display_longest

    puts Vanilla::Output::Terminal.new(grid, open_maze: open_maze)

    if png
      require_relative 'vanilla/output/png'
      Vanilla::Output::Png.new(grid).to_png
    end
  end

  def self.start_and_goal_points(grid:)
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

    start_and_goal_points.shuffle.shift(2)
  end

  # uses Dijkstra’s algorithm
  def self.display_distances(grid:, start:, goal:)
    puts "displaying path distance from start to goal:"

    distances = start.distances

    puts "start: [#{start.row}, #{start.column}] goal: [#{goal.row}, #{goal.column}]"

    grid.distances = distances.path_to(goal)

    grid
  end

  # Uses Dijkstra's distance to calculate the longest path
  # the path given doesn't mean it's the only longest path,
  # but one between the longest possible paths
  #
  # In the future:
  # We can use this to decide wether the maze has enough complexity,
  # and we can tie it to the characters experience / level
  def self.longest_path(grid:, start:)
    distances = start.distances
    new_start, distance = distances.max

    new_distances = new_start.distances
    goal, distances = new_distances.max

    grid.distances = new_distances.path_to(goal)

    grid
  end
end
