require 'spec_helper'
require 'vanilla/world'
require 'vanilla/characters/player'
require 'vanilla/map_utils/grid'
require 'vanilla/support/tile_type'
require 'vanilla/commands/movement_command'

RSpec.describe "Level Transition" do
  let(:world) { Vanilla::World.new }
  let(:grid) { Vanilla::MapUtils::Grid.new(3, 3) }
  let(:player) { Vanilla::Characters::Player.new(grid: grid, row: 1, col: 1) }
  let(:transform) { player.get_component(Vanilla::Components::TransformComponent) }

  before do
    # Initialize grid with floor tiles and stairs
    grid.each_cell do |cell|
      cell.tile = Vanilla::Support::TileType::FLOOR
    end
    grid.get(1, 2).tile = Vanilla::Support::TileType::STAIRS
    world.add_entity(player)
  end

  describe "Player Movement to Stairs" do
    it "should move player to stairs position" do
      puts "\nInitial state:"
      puts "Player position: #{player.position.inspect}"
      puts "Current cell tile: #{transform.current_cell.tile}"
      
      command = Vanilla::Commands::MovementCommand.new(world, player, [0, 1])
      result = command.execute
      
      puts "\nAfter movement:"
      puts "Command result: #{result}"
      puts "Player position: #{player.position.inspect}"
      puts "Current cell tile: #{transform.current_cell.tile}"
      
      expect(result).to be true
      expect(player.position).to eq([1, 1])
      expect(transform.current_cell.tile).to eq(Vanilla::Support::TileType::PLAYER)
    end

    it "should create new grid and transition player" do
      puts "\nInitial state:"
      puts "Grid ID: #{grid.object_id}"
      puts "Player position: #{player.position.inspect}"
      puts "Current cell tile: #{transform.current_cell.tile}"
      
      command = Vanilla::Commands::MovementCommand.new(world, player, [0, 1])
      result = command.execute
      
      puts "\nAfter transition:"
      puts "Command result: #{result}"
      puts "New grid ID: #{transform.grid.object_id}"
      puts "Player position: #{player.position.inspect}"
      puts "Current cell tile: #{transform.current_cell.tile}"
      
      expect(result).to be true
      expect(transform.grid).not_to eq(grid)
      expect(player.position).to eq([1, 1])
      expect(transform.current_cell.tile).to eq(Vanilla::Support::TileType::PLAYER)
    end

    it "should maintain player state during transition" do
      puts "\nInitial state:"
      puts "Player health: #{player.stats.health}"
      puts "Player level: #{player.stats.level}"
      puts "Player position: #{player.position.inspect}"
      
      command = Vanilla::Commands::MovementCommand.new(world, player, [0, 1])
      result = command.execute
      
      puts "\nAfter transition:"
      puts "Player health: #{player.stats.health}"
      puts "Player level: #{player.stats.level}"
      puts "Player position: #{player.position.inspect}"
      
      expect(result).to be true
      expect(player.stats.health).to eq(100)
      expect(player.stats.level).to eq(1)
    end

    it "should emit level transition event" do
      event_emitted = false
      world.event_manager.on(:level_transition) do |data|
        event_emitted = true
        puts "\nLevel transition event data:"
        puts "Old grid ID: #{data[:old_grid].object_id}"
        puts "New grid ID: #{data[:new_grid].object_id}"
        puts "Entity ID: #{data[:entity].id}"
      end
      
      command = Vanilla::Commands::MovementCommand.new(world, player, [0, 1])
      result = command.execute
      
      expect(result).to be true
      expect(event_emitted).to be true
    end
  end

  describe "Grid State Management" do
    it "should clear old position in previous grid" do
      old_position = player.position
      old_cell = transform.current_cell
      
      puts "\nInitial state:"
      puts "Old position: #{old_position.inspect}"
      puts "Old cell tile: #{old_cell.tile}"
      
      command = Vanilla::Commands::MovementCommand.new(world, player, [0, 1])
      command.execute
      
      puts "\nAfter transition:"
      puts "Old cell tile: #{old_cell.tile}"
      
      expect(old_cell.tile).to eq(Vanilla::Support::TileType::FLOOR)
    end

    it "should initialize new grid with proper tiles" do
      command = Vanilla::Commands::MovementCommand.new(world, player, [0, 1])
      command.execute
      
      new_grid = transform.grid
      puts "\nNew grid state:"
      puts "Grid size: #{new_grid.rows}x#{new_grid.cols}"
      
      # Check for stairs
      stairs_found = false
      new_grid.each_cell do |cell|
        if cell.tile == Vanilla::Support::TileType::STAIRS
          stairs_found = true
          break
        end
      end
      
      expect(stairs_found).to be true
    end
  end
end 