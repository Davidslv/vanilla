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
  require_relative 'vanilla/map_utils'
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

  # characters
  require_relative 'vanilla/characters/player'

  # commands
  require_relative 'vanilla/command'

  # new level
  require_relative 'vanilla/new_level'

  $seed = nil

  def self.run
    # level = Vanilla::NewLevel.new(seed: 84625887428918)
    level = Vanilla::NewLevel.new

    while key = STDIN.getch
      # Given that arrow keys are compose of more than one character
      # we are taking advantage of STDIN repeatedly to represent the correct action.
      # It's not a perfect solution but it does avoid using Ncurses/Curses
      second_key = STDIN.getch if key == "\e"
      key        = STDIN.getch if second_key == "["
      key        = KEYBOARD_ARROWS[key.intern] || key

      Vanilla::Command.process(key: key, grid: level.grid, unit: level.player)
      level = Vanilla::NewLevel.random if level.player.found_stairs?
    end
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
    grid = Vanilla::Map.create(rows: rows, columns: columns, algorithm: algorithm, seed: seed)

    start, goal = self.start_and_goal_points(grid: grid)          if display_distances || display_longest
    self.display_distances(grid: grid, start: start, goal: goal)  if (display_distances && !display_longest)
    Vanilla::Algorithms::LongestPath.on(grid, start: start)       if display_longest

    Vanilla::Draw.map(grid, open_maze: open_maze)

    if png
      require_relative 'vanilla/output/png'
      Vanilla::Output::Png.new(grid, algorithm: algorithm, seed: $seed, start: start, goal: goal).to_png
    end
  end

  # defines the start position and end position
  # recalculates end position when it is the same as start position
  def self.start_and_goal_points(grid:)
    start_position = grid[rand(0...grid.rows), rand(0...grid.columns)]
    end_position = grid[rand(0...grid.rows), rand(0...grid.columns)]

    until start_position != end_position
      end_position = grid[rand(0...grid.rows), rand(0...grid.columns)]
    end

    [start_position, end_position]
  end

  # uses Dijkstra’s algorithm
  def self.display_distances(grid:, start:, goal:)
    puts "displaying path distance from start to goal:"

    distances = start.distances

    puts "start: [#{start.row}, #{start.column}] goal: [#{goal.row}, #{goal.column}]"

    grid.distances = distances.path_to(goal)

    grid
  end
end
