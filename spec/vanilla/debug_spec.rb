RSpec.describe Vanilla::Debug do
  describe '.verify_game_state' do
    let(:state) { described_class.verify_game_state }

    it 'creates a world instance' do
      expect(state[:world]).to be_a(Vanilla::World)
    end

    it 'creates a 3x3 grid' do
      grid = state[:grid]
      expect(grid.rows).to eq(3)
      expect(grid.columns).to eq(3)
    end

    it 'creates a player at position (1,1)' do
      player = state[:player]
      expect(player.position).to eq([1, 1])
    end

    it 'includes required components' do
      components = state[:status][:components]
      expect(components).to include(
        Vanilla::Components::TransformComponent,
        Vanilla::Components::CombatComponent,
        Vanilla::Components::StatsComponent
      )
    end

    it 'includes required systems' do
      systems = state[:status][:systems]
      expect(systems).to include(
        Vanilla::Systems::InputSystem,
        Vanilla::Systems::MessageSystem
      )
    end
  end

  describe '.load_game' do
    context 'when successful' do
      it 'returns game state' do
        result = described_class.load_game
        expect(result[:world]).to be_a(Vanilla::World)
      end
    end

    context 'when there is an error' do
      before do
        allow(described_class).to receive(:verify_game_state).and_raise('Test error')
      end

      it 'returns error information' do
        result = described_class.load_game
        expect(result[:error]).to be_a(RuntimeError)
        expect(result[:message]).to eq('Test error')
        expect(result[:backtrace]).to be_an(Array)
      end
    end
  end
end 