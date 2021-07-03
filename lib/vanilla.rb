require 'pry'

module Vanilla
  # required to use STDIN.getch
  # in order to avoid pressing enter to submit input to the game
  require 'io/console'

  # Keyboard arrow keys are compose of 3 characters
  #
  # UP    -> \e[A
  # DOWN  -> \e[B
  # RIGHT -> \e[C
  # LEFT  -> \e[D
  KEYBOARD_ARROWS = {
    A: :KEY_UP,
    B: :KEY_DOWN,
    C: :KEY_RIGHT,
    D: :KEY_LEFT
  }.freeze

  # demo
  require_relative 'vanilla/demo'

  # draw
  require_relative 'vanilla/draw'

  # map
  require_relative 'vanilla/map'

  # output
  require_relative 'vanilla/output/terminal'

  # algorithms
  require_relative 'vanilla/algorithms'

  # support
  require_relative 'vanilla/support/tile_type'

  # movement
  require_relative 'vanilla/movement'

  # unit
  require_relative 'vanilla/unit'

  # commands
  require_relative 'vanilla/command'

  $seed = nil

  def self.run
    grid = Vanilla.create_grid(rows: 10, columns: 10, seed: 84625887428918);
    player = Vanilla::Unit.new(row: 9, column: 3, tile: Vanilla::Support::TileType::PLAYER)

    Vanilla::Draw.player(grid: grid, unit: player)
    Vanilla::Draw.stairs(grid: grid, row: 9, column: 0)

    while key = STDIN.getch
      # Given that arrow keys are compose of more than one character
      # we are taking advantage of STDIN repeatedly to represent the correct action.
      # It's not a perfect solution but it does avoid using Ncurses/Curses
      second_key = STDIN.getch if key == "\e"
      key        = STDIN.getch if second_key == "["
      key        = KEYBOARD_ARROWS[key.intern] || key

      Vanilla::Command.process(key: key, grid: grid, unit: player)
    end
  end

  def self.create_grid(rows:, columns:, algorithm: Vanilla::Algorithms::BinaryTree, seed: nil, open_maze: true)
    $seed = seed || rand(999_999_999_999_999)
    puts "Seed: #{$seed}"

    srand($seed)

    grid = Vanilla::Map::Grid.new(rows: rows, columns: columns)
    algorithm.on(grid)
    grid.dead_ends

    grid
  end


  # @param rows [Integer] is the vertical length of the map
  # @param columns [Integer] is the  horizontal length of the map
  # @param algorithm [Object] choose the class object of the algorithm you would like to use
  # @param png [Boolean] creates a png file from the generated map
  # @param display_distances [Boolean] displays a distance from two random points on the grid
  # @param display_longest [Boolean] displays the longest possible distance between two points on the grid, uses Djikra's algorithm
  # @param open_maze [Boolean] displays a different render output
  # @param seed [Integer] is the number necessary to regenerate a given grid
  def self.play(rows: 10, columns: 10, algorithm: Vanilla::Algorithms::BinaryTree, png: false, display_distances: false, display_longest: false, open_maze: true, seed: nil)
    $seed = seed || rand(999_999_999_999_999)
    grid = create_grid(rows: rows, columns: columns, algorithm: algorithm, seed: seed)

    start, goal = self.start_and_goal_points(grid: grid)          if display_distances || display_longest
    self.display_distances(grid: grid, start: start, goal: goal)  if (display_distances && !display_longest)
    self.longest_path(grid: grid , start: start)                  if display_longest

    Vanilla::Draw.map(grid)

    if png
      require_relative 'vanilla/output/png'
      Vanilla::Output::Png.new(grid, algorithm: algorithm, seed: $seed, start: start, goal: goal).to_png
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

    puts "displaying longest path from start point to goal:"
    puts "start: [#{new_start.row}, #{new_start.column}] goal: [#{goal.row}, #{goal.column}]"

    grid
  end
end
