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
        world.event_manager.subscribe(:movement_completed) do |data|
          add_message("You move to #{data[:to].join(',')}")
        end

        world.event_manager.subscribe(:combat_initiated) do |data|
          add_message("You engage in combat!")
        end

        world.event_manager.subscribe(:stairs_found) do |data|
          add_message("You found stairs leading to another level!")
          add_message("Descending to the next level...")
        end

        world.event_manager.subscribe(:invalid_command) do |data|
          add_message("Invalid command: #{data[:key]}")
        end

        world.event_manager.subscribe(:command_failed) do |data|
          add_message("Can't do that!")
        end

        world.event_manager.subscribe(:hit_wall) do |data|
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