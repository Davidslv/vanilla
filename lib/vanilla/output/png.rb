require 'chunky_png'

module Vanilla
  module Output
    class Png
      CONFIG = [
        BACKGROUND_COLOR = ChunkyPNG::Color::WHITE,
        WALL_COLOR = ChunkyPNG::Color::BLACK,
        START_COLOR = ChunkyPNG::Color('green @ 0.7'),
        GOAL_COLOR = ChunkyPNG::Color('red @ 0.6')
      ].freeze

      def initialize(grid, start: nil, goal: nil, algorithm:, seed:)
        @grid = grid
        @start = start
        @goal  = goal
        @algorithm_name = algorithm.demodulize
        @seed = seed
      end

      def to_png(cell_size: 20)
        img_width = cell_size * @grid.columns
        img_height = cell_size * @grid.rows

        img = ChunkyPNG::Image.new(img_width + 1, img_height + 1, BACKGROUND_COLOR)

        @grid.each_cell do |cell|
          x1 = cell.column * cell_size
          y1 = cell.row * cell_size
          x2 = (cell.column + 1) * cell_size
          y2 = (cell.row + 1) * cell_size

          if cell == @start
            img.rect(x1, y1, x2, y2, START_COLOR, START_COLOR)
          elsif cell == @goal
            img.rect(x1, y1, x2, y2, GOAL_COLOR, GOAL_COLOR)
          else
            img.line(x1, y1, x2, y1, WALL_COLOR) unless cell.north
            img.line(x1, y1, x1, y2, WALL_COLOR) unless cell.west
            img.line(x2, y1, x2, y2, WALL_COLOR) unless cell.linked?(cell.east)
            img.line(x1, y2, x2, y2, WALL_COLOR) unless cell.linked?(cell.south)
          end
        end

        FileUtils.mkdir_p(path)
        img.save "#{path}/maze_#{@seed}.png"

        img
      end

      def path
        "png-mazes/#{@algorithm_name}"
      end
    end
  end
end
