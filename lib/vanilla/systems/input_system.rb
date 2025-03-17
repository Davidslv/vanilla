require_relative 'base_system'
require_relative '../commands/movement_command'

module Vanilla
  module Systems
    # System that handles keyboard input and converts it to game commands
    class InputSystem < BaseSystem
      MOVEMENT_KEYS = {
        'h' => [0, -1],  # left
        'l' => [0, 1],   # right
        'k' => [-1, 0],  # up
        'j' => [1, 0],   # down
      }.freeze

      # Initialize the input system
      #
      # @param world [World] The game world
      # @param player [Entity] The player entity
      def initialize(world, player)
        super()
        @world = world
        @player = player
      end

      # Process keyboard input and create appropriate commands
      #
      # @param input [String] The keyboard input
      # @return [BaseCommand, nil] The command to execute, or nil if input is invalid
      def update(input)
        return nil unless input && input.length == 1

        command = create_command(input)
        if command
          command.execute
        end
      end

      private

      def create_command(key)
        if MOVEMENT_KEYS.key?(key)
          return nil unless @player
          Commands::MovementCommand.new(@world, @player, MOVEMENT_KEYS[key])
        elsif key == 'q'
          Events::EventManager.emit(:quit_game)
          nil
        else
          Events::EventManager.emit(:invalid_command, key: key)
          nil
        end
      end
    end
  end
end 