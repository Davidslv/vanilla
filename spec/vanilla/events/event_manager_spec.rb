RSpec.describe Vanilla::Events::EventManager do
  subject(:event_manager) { described_class.new }

  describe '#on' do
    it 'registers an event handler' do
      handler_called = false
      event_manager.on(:test_event) { handler_called = true }
      event_manager.trigger(:test_event)
      expect(handler_called).to be true
    end

    it 'can register multiple handlers for the same event' do
      count = 0
      event_manager.on(:test_event) { count += 1 }
      event_manager.on(:test_event) { count += 1 }
      event_manager.trigger(:test_event)
      expect(count).to eq(2)
    end
  end

  describe '#trigger' do
    it 'passes data to the handler' do
      received_data = nil
      event_manager.on(:test_event) { |data| received_data = data }
      event_manager.trigger(:test_event, value: 42)
      expect(received_data).to eq(value: 42)
    end

    it 'does nothing if no handlers are registered' do
      expect { event_manager.trigger(:nonexistent_event) }.not_to raise_error
    end
  end

  describe '#clear' do
    it 'removes all event handlers' do
      handler_called = false
      event_manager.on(:test_event) { handler_called = true }
      event_manager.clear
      event_manager.trigger(:test_event)
      expect(handler_called).to be false
    end
  end
end 