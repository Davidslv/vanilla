require 'ostruct'
require 'chunky_png'
require 'pry'

# support
require_relative 'vanilla/support/tile_type'

# map utils
require_relative 'vanilla/map_utils/cell'
require_relative 'vanilla/map_utils/grid'

# algorithms
require_relative 'vanilla/algorithms/abstract_algorithm'
require_relative 'vanilla/algorithms/binary_tree'

# output
require_relative 'vanilla/output/terminal'

# characters
require_relative 'vanilla/characters/player'
require_relative 'vanilla/characters/monster'

# map
require_relative 'vanilla/map'
require_relative 'vanilla/draw'
require_relative 'vanilla/level'

# version
require_relative 'vanilla/version'

# entity
require_relative 'vanilla/entity'

# components
require_relative 'vanilla/components/base_component'
require_relative 'vanilla/components/transform_component'
require_relative 'vanilla/components/stats_component'

# commands
require_relative 'vanilla/command'

module Vanilla
  class Error < StandardError; end

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

  $seed = nil

  def self.run
    # Create initial grid with minimum dimensions from Level class
    initial_grid = Map.create(
      rows: Level::MIN_ROWS,
      columns: Level::MIN_COLUMNS,
      algorithm: Algorithms::BinaryTree,
      seed: rand(999_999_999_999_999)
    )

    # Create the player with the initial grid
    current_player = Characters::Player.new(
      row: 1,
      column: 1,
      grid: initial_grid,
      name: 'Hero'
    )

    # Create the first level
    level = Level.new(grid: initial_grid, player: current_player)

    loop do
      level.terminal.clear
      level.update

      key = STDIN.getch
      Command.process(key: key, grid: level.grid, player: current_player, terminal: level.terminal)

      if current_player.found_stairs?
        # Create a new level with increased size for progression
        rows = [level.grid.rows + rand(2..4), Level::MAX_ROWS].min
        columns = [level.grid.columns + rand(2..4), Level::MAX_COLUMNS].min
        
        level = Level.random(
          player: current_player,
          rows: rows,
          columns: columns
        )
        
        current_player.found_stairs = false
      end
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

    start, goal = self.start_and_goal_points(grid: grid) if display_distances || display_longest
    self.display_distances(grid: grid, start: start, goal: goal) if (display_distances && !display_longest)
    Vanilla::Algorithms::LongestPath.on(grid, start: start) if display_longest

    Vanilla::Draw.map(grid, open_maze: open_maze)
  end

  # defines the start position and end position
  # recalculates end position when it is the same as start position
  def self.start_and_goal_points(grid:)
    start_position = grid[rand(0...grid.rows), rand(0...grid.columns)]
    end_position = grid[rand(0...grid.rows), rand(0...grid.columns)]

    until start_position != end_position
      end_position = grid[rand(0...grid.rows), rand(0...grid.columns)]
    end

    [start_position, end_position]
  end

  # uses Dijkstra's algorithm
  def self.display_distances(grid:, start:, goal:)
    puts "displaying path distance from start to goal:"

    distances = start.distances

    puts "start: [#{start.row}, #{start.column}] goal: [#{goal.row}, #{goal.column}]"

    grid.distances = distances.path_to(goal)

    grid
  end
end
