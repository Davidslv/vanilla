require_relative 'base_system'
require_relative '../commands/movement_command'

module Vanilla
  module Systems
    class InputSystem < BaseSystem
      def initialize(world)
        super
        @command_queue = []
      end

      def process_input(key)
        command = create_command(key)
        @command_queue << command if command
      end

      def update(delta_time)
        while command = @command_queue.shift
          result = command.execute
          handle_command_result(command, result)
        end
      end

      private

      def create_command(key)
        player = find_player
        return unless player

        case key
        when 'h'
          Commands::MovementCommand.new(world: world, entity: player, direction: :left)
        when 'j'
          Commands::MovementCommand.new(world: world, entity: player, direction: :down)
        when 'k'
          Commands::MovementCommand.new(world: world, entity: player, direction: :up)
        when 'l'
          Commands::MovementCommand.new(world: world, entity: player, direction: :right)
        when "\C-c", "q"
          emit_event(:quit_game)
          nil
        else
          emit_event(:invalid_command, key: key)
          nil
        end
      end

      def handle_command_result(command, result)
        return unless command

        if result
          emit_event(:command_succeeded, command: command.class.name)
        else
          emit_event(:command_failed, command: command.class.name)
        end
      end

      def find_player
        # In a real implementation, you'd want to cache this
        world.entities_with_components(Components::TransformComponent).first
      end

      def emit_event(type, data = {})
        world.event_manager.trigger(type, data)
      end
    end
  end
end 