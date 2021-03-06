module Vanilla
  module MapUtils
    class Cell
      attr_reader :row, :column
      attr_accessor :north, :south, :east, :west
      attr_accessor :dead_end, :tile

      def initialize(row:, column:)
        @row, @column = row, column
        @links = {}
      end

      # cell x, y position
      def position
        [row, column]
      end

      def link(cell:, bidirectional: true)
        @links[cell] = true
        cell.link(cell: self, bidirectional: false) if bidirectional

        self
      end

      def unlink(cell:, bidirectional: true)
        @links.delete(cell)
        cell.unlink(cell: self, bidirectional: false) if bidirectional
      end

      def links
        @links.keys
      end

      def linked?(cell)
        @links.key?(cell)
      end

      def dead_end?
        !! dead_end
      end

      def player?
        tile == Support::TileType::PLAYER
      end

      def stairs?
        tile == Support::TileType::STAIRS
      end

      def neighbors
        list = []
        list << north if north
        list << south if south
        list << east if east
        list << west if west

        list
      end

      def distances
        distances = Vanilla::MapUtils::DistanceBetweenCells.new(self)
        frontier = [ self ]

        # We’re going to keep looping until there are no more cells in the frontier set,
        # which will mean that we’ve measured the distance of every cell to our root cell.
        while frontier.any?
          new_frontier = []

          frontier.each do |cell|
            cell.links.each do |linked|
              next if distances[linked]

              distances[linked] = distances[cell] + 1
              new_frontier << linked
            end
          end

          frontier = new_frontier
        end

        distances
      end
    end
  end
end
