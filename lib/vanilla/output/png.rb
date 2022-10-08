require 'chunky_png'

module Vanilla
  module Output
    class Png
      CONFIG = [
        TRANSPARENT = ChunkyPNG::Color::TRANSPARENT,
        BACKGROUND_COLOR = ChunkyPNG::Color::WHITE,
        WALL_COLOR = ChunkyPNG::Color::BLACK,
        START_COLOR = ChunkyPNG::Color('black @ 0.2'),
        GOAL_COLOR = ChunkyPNG::Color('black @ 0.7')
      ].freeze

      def initialize(grid, start: nil, goal: nil, algorithm:, seed:)
        @grid = grid
        @start = start
        @goal  = goal
        @algorithm_name = algorithm.demodulize
        @seed = seed
      end

      def to_png(cell_size: 128)
        img_width = cell_size * @grid.columns
        img_height = cell_size * @grid.rows

        img = ChunkyPNG::Image.new(img_width + 1, img_height + 1, BACKGROUND_COLOR)

        @grid.each_cell do |cell|
          x1 = cell.column * cell_size
          y1 = cell.row * cell_size
          x2 = (cell.column + 1) * cell_size
          y2 = (cell.row + 1) * cell_size

          # circle calculations
          circle_size = cell_size / 3
          x_center = (x1 + x2) / 2
          y_center = (y1 + y2) / 2

          if (cell == @start || cell == @goal)
            color = (cell == @start) ? START_COLOR : GOAL_COLOR
            img.circle(x_center, y_center, circle_size, color, color)
          else
            img.line(x1, y1, x2, y1, WALL_COLOR) unless cell.north
            img.line(x1, y1, x1, y2, WALL_COLOR) unless cell.west
            img.line(x2, y1, x2, y2, WALL_COLOR) unless cell.linked?(cell.east)
            img.line(x1, y2, x2, y2, WALL_COLOR) unless cell.linked?(cell.south)
          end
        end

        FileUtils.mkdir_p(path)
        img.save(file_path)
      end

      private
        def path
          "png-mazes/#{@algorithm_name}"
        end

        def file_path
          "#{path}/maze_#{@seed}.png"
        end
    end
  end
end
