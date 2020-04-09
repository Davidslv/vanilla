module Vanilla
  module Output
    class Terminal
      def initialize(grid)
        @grid = grid
      end

      def to_s
        output = "+" + "---+" * @grid.columns + "\n"

        @grid.each_row do |row|
          top = "|"
          bottom = "+"

          row.each do |cell|
            next unless cell

            body = " #{@grid.contents_of(cell)} "
            east_boundary = (cell.linked?(cell.east) ? " " : "|")
            top << body << east_boundary

            south_boundary = (cell.linked?(cell.south) ? "   " : "---")
            corner = "+"
            bottom << south_boundary << corner
          end

          output << top << "\n"
          output << bottom << "\n"
        end

        output
      end
    end
  end
end
