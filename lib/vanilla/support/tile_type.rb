module Vanilla
  module Support
    module TileType
      FLOOR = ' '
      WALL = '#'
      PLAYER = '@'
      MONSTER = 'M'
      STAIRS = '%'
      UNKNOWN = '?'

      VALUES = [FLOOR, WALL, PLAYER, MONSTER, STAIRS, UNKNOWN].freeze

      def self.valid?(tile)
        VALUES.include?(tile)
      end

      def self.tile_to_s(tile)
        raise ArgumentError, "Invalid tile type: #{tile}" unless valid?(tile)
        tile
      end
    end
  end
end
