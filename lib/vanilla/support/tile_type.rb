module Vanilla
  module Support
    class TileType
      VALUES = [
        EMPTY   = ' '.freeze,
        WALL    = '#'.freeze,
        DOOR    = '/'.freeze,
        FLOOR   = '.'.freeze,
        PLAYER  = '@'.freeze,
        STAIRS  = '%'.freeze,
        PASSAGE = '='.freeze,
        VERTICAL_WALL = '|'.freeze
      ].freeze

      def self.values
        VALUES
      end
    end
  end
end
