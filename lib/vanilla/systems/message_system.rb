require_relative 'base_system'

module Vanilla
  module Systems
    class MessageSystem < BaseSystem
      def initialize(world)
        super
        @messages = []
        setup_event_handlers
      end

      def update(delta_time)
        # Messages are handled through events
      end

      def messages
        @messages.dup
      end

      def clear_messages
        @messages.clear
      end

      private

      def setup_event_handlers
        world.event_manager.on(:movement_completed) do |data|
          add_message("You moved #{data[:direction]}")
        end

        world.event_manager.on(:combat_initiated) do |data|
          add_message("Combat started with #{data[:target].name}")
        end

        world.event_manager.on(:stairs_found) do |_data|
          add_message("You found stairs!")
        end

        world.event_manager.on(:invalid_command) do |data|
          add_message("Invalid command: #{data[:reason]}")
        end

        world.event_manager.on(:command_failed) do |data|
          add_message("Command failed: #{data[:reason]}")
        end

        world.event_manager.on(:hit_wall) do |_data|
          add_message("You hit a wall!")
        end
      end

      def add_message(message)
        @messages << message
        emit_event(:message_added, message: message)
      end

      def emit_event(type, data = {})
        world.event_manager.trigger(type, data)
      end
    end
  end
end 