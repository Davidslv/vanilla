require_relative 'base_system'

module Vanilla
  module Systems
    # System that manages game messages and notifications
    class MessageSystem < BaseSystem
      attr_reader :messages

      # Initialize a new message system
      #
      # @param world [World] The game world
      def initialize(world)
        super()
        @world = world
        @messages = []
        register_event_handlers
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

      def register_event_handlers
        world.event_manager.on(:movement_completed) { |data| handle_movement_completed(data) }
        world.event_manager.on(:combat_initiated) { |data| handle_combat_initiated(data) }
        world.event_manager.on(:combat_executed) { |data| handle_combat_executed(data) }
        world.event_manager.on(:target_survived) { |data| handle_target_survived(data) }
        world.event_manager.on(:target_defeated) { |data| handle_target_defeated(data) }
        world.event_manager.on(:experience_gained) { |data| handle_experience_gained(data) }
        world.event_manager.on(:stairs_found) { |data| handle_stairs_found(data) }
        world.event_manager.on(:invalid_command) { |data| handle_invalid_command(data) }
        world.event_manager.on(:command_failed) { |data| handle_command_failed(data) }
        world.event_manager.on(:hit_wall) { |data| handle_hit_wall(data) }
      end

      def handle_movement_completed(data)
        add_message("Moved to position (#{data[:to][0]}, #{data[:to][1]})")
      end

      def handle_combat_initiated(data)
        add_message("Engaging in combat with #{data[:target].name}")
      end

      def handle_combat_executed(data)
        add_message("Dealt #{data[:damage]} damage")
      end

      def handle_target_survived(data)
        add_message("#{data[:target].name} survived the attack")
      end

      def handle_target_defeated(data)
        add_message("#{data[:target].name} was defeated!")
      end

      def handle_experience_gained(data)
        add_message("Gained #{data[:amount]} experience points")
      end

      def handle_stairs_found(data)
        add_message("Found stairs! Press '>' to descend")
      end

      def handle_invalid_command(data)
        add_message("Invalid command: #{data[:key]}")
      end

      def handle_command_failed(data)
        add_message("Cannot execute that command")
      end

      def handle_hit_wall(data)
        add_message("You hit a wall")
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