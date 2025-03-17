require 'spec_helper'
require 'vanilla/output/terminal'
require 'vanilla/map_utils/grid'

RSpec.describe Vanilla::Output::Terminal do
  let(:grid) { Vanilla::MapUtils::Grid.new(rows: 3, columns: 3) }
  let(:terminal) { described_class.new(grid: grid) }

  describe '#initialize' do
    it 'creates a terminal with the given grid' do
      expect(terminal.grid).to eq(grid)
    end

    it 'initializes with empty messages' do
      expect(terminal.messages).to be_empty
    end
  end

  describe '#add_message' do
    it 'adds a message to the messages array' do
      terminal.add_message('Test message')
      expect(terminal.messages).to include('Test message')
    end

    it 'adds multiple messages' do
      terminal.add_message('First message')
      terminal.add_message('Second message')
      expect(terminal.messages).to eq(['First message', 'Second message'])
    end
  end

  describe '#clear_messages' do
    it 'clears all messages' do
      terminal.add_message('Test message')
      terminal.clear_messages
      expect(terminal.messages).to be_empty
    end
  end

  describe '#to_s' do
    it 'includes messages below the grid' do
      terminal.add_message('Test message')
      output = terminal.to_s
      expect(output).to include('Test message')
    end

    it 'separates grid and messages with a newline' do
      terminal.add_message('Test message')
      output = terminal.to_s
      expect(output).to match(/...\nTest message/)
    end
  end
end 