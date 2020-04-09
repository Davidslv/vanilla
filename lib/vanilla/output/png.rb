require 'chunky_png'

module Vanilla
  module Output
    class Png
      def initialize(grid, start: nil, goal: nil)
        @grid = grid
        @start = start
        @goal  = goal
      end

      def to_png(cell_size: 20)
        img_width = cell_size * @grid.columns
        img_height = cell_size * @grid.rows

        background = ChunkyPNG::Color::BLACK
        wall = ChunkyPNG::Color::WHITE
        start_color = ChunkyPNG::Color('green @ 0.7')
        goal_color = ChunkyPNG::Color('red @ 0.6')

        img = ChunkyPNG::Image.new(img_width + 1, img_height + 1, background)

        @grid.each_cell do |cell|
          x1 = cell.column * cell_size
          y1 = cell.row * cell_size
          x2 = (cell.column + 1) * cell_size
          y2 = (cell.row + 1) * cell_size

          if cell == @start
            img.rect(x1, y1, x2, y2, start_color, start_color) if start_color
          elsif cell == @goal
            img.rect(x1, y1, x2, y2, goal_color, goal_color) if goal_color
          else
            img.line(x1, y1, x2, y1, wall) unless cell.north
            img.line(x1, y1, x1, y2, wall) unless cell.west
            img.line(x2, y1, x2, y2, wall) unless cell.linked?(cell.east)
            img.line(x1, y2, x2, y2, wall) unless cell.linked?(cell.south)
          end
        end

        img.save "maze_#{rand(1...250)}.png"

        img
      end
    end
  end
end
