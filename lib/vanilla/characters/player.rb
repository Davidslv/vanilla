
module Vanilla
  module Characters
    class Player < Unit
      attr_accessor :name, :level, :experience, :inventory

      def initialize(name: 'player', row:, column:)
        super(row: row, column: column, tile: Support::TileType::PLAYER)
        @name = name
        
        @level = 1
        @experience = 0
        @inventory = []
      end

      def gain_experience(amount)
        @experience += amount
        level_up if @experience >= experience_to_next_level
      end

      def level_up
        @level += 1
        @experience -= experience_to_next_level
        # Add level up bonuses here
      end

      def add_to_inventory(item)
        @inventory << item
      end

      def remove_from_inventory(item)
        @inventory.delete(item)
      end

      private

      def experience_to_next_level
        @level * 100 # Simple formula, can be adjusted
      end
    end
  end
end