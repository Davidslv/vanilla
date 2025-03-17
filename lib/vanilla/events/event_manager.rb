module Vanilla
  module Events
    # EventManager handles the registration and triggering of events throughout the game.
    # It provides a simple pub/sub system for game components to communicate.
    #
    # @example
    #   manager = EventManager.new
    #   manager.on(:movement_completed) { |data| puts "Entity moved to #{data[:position]}" }
    #   manager.trigger(:movement_completed, position: [1, 2])
    class EventManager
      # Initialize a new EventManager with an empty handlers hash
      def initialize
        @handlers = Hash.new { |h, k| h[k] = [] }
      end

      # Register a handler for a specific event
      #
      # @param event_name [Symbol] The name of the event to listen for
      # @yield [data] The block to execute when the event is triggered
      # @yieldparam data [Hash] The data passed when the event is triggered
      def on(event_name, &handler)
        @handlers[event_name] << handler
      end

      # Trigger an event with optional data
      #
      # @param event_name [Symbol] The name of the event to trigger
      # @param data [Hash] Optional data to pass to the event handlers
      def trigger(event_name, data = {})
        @handlers[event_name].each do |handler|
          handler.call(data)
        end
      end

      # Clear all event handlers
      def clear
        @handlers.clear
      end
    end
  end
end 