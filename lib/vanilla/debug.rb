module Vanilla
  # Debug module provides tools and utilities for testing and debugging the game state.
  # It includes methods for creating test environments and safely loading the game.
  module Debug
    class << self
      # Creates a minimal test environment with a world, grid, and player
      #
      # @return [Hash] A hash containing:
      #   - :world [World] The game world instance
      #   - :grid [MapUtils::Grid] A 3x3 grid
      #   - :player [Characters::Player] A player entity at position (1,1)
      #   - :status [Hash] Current game state information including:
      #     - :player_position [Array] Current player coordinates
      #     - :components [Array] List of loaded components
      #     - :systems [Array] List of active systems
      def verify_game_state
        world = World.new
        grid = MapUtils::Grid.new(rows: 3, columns: 3)
        
        # Create and add player
        player = Characters::Player.new(
          grid: grid,
          row: 1,
          col: 1
        )
        world.add_entity(player)

        {
          world: world,
          grid: grid,
          player: player,
          status: {
            player_position: player.position,
            components: player.components.keys,
            systems: world.systems.map(&:class)
          }
        }
      end

      # Safely attempts to load the game and returns either the game state or error information
      #
      # @return [Hash] Either:
      #   - A successful game state from verify_game_state
      #   - An error hash containing:
      #     - :error [Exception] The caught exception
      #     - :message [String] The error message
      #     - :backtrace [Array] First 5 lines of the error backtrace
      def load_game
        require_relative '../vanilla'
        verify_game_state
      rescue => e
        {
          error: e,
          message: e.message,
          backtrace: e.backtrace.first(5)
        }
      end
    end
  end
end 