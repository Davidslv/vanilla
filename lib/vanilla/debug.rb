require_relative './world'
require_relative './support/tile_type'
require_relative './map_utils/grid'
require_relative './components/transform_component'
require_relative './commands/movement_command'
require_relative './events/event_manager'
require_relative './systems/input_system'
require_relative './entity'

module Vanilla
  # Debug module provides tools and utilities for testing and debugging the game state.
  # It includes methods for creating test environments and safely loading the game.
  module Debug
    class << self
      # Creates a minimal test environment with a world, grid, and player
      #
      # @return [Hash] A hash containing:
      #   - :world [World] The game world instance
      #   - :grid [MapUtils::Grid] A 3x3 grid
      #   - :player [Characters::Player] A player entity at position (1,1)
      #   - :status [Hash] Current game state information including:
      #     - :player_position [Array] Current player coordinates
      #     - :components [Array] List of loaded components
      #     - :systems [Array] List of active systems
      def verify_game_state
        world = World.new
        grid = MapUtils::Grid.new(3, 3)
        
        # Create and add player
        player = Characters::Player.new(
          grid: grid,
          row: 1,
          col: 1
        )
        world.add_entity(player)

        # Add input system
        world.add_system(Systems::InputSystem.new(world, player))

        {
          world: world,
          grid: grid,
          player: player,
          status: {
            player_position: player.position,
            components: player.components.keys,
            systems: world.systems.map(&:class)
          }
        }
      end

      # Test grid rendering with all tile types
      #
      # @return [Hash] Test results with success status and error details
      def test_grid_rendering
        results = { success: true, errors: [] }
        
        # Create a test grid with all tile types
        grid = MapUtils::Grid.new(5, 5)
        
        # Place different tile types
        grid.set(0, 0, Support::TileType::WALL)  # Wall
        grid.set(0, 1, Support::TileType::FLOOR) # Floor
        grid.set(0, 2, Support::TileType::STAIRS) # Stairs
        
        # Create player
        player = Characters::Player.new(
          grid: grid,
          row: 0,
          col: 3
        )
        
        # Create monster
        monster = Characters::Monster.new(
          grid: grid,
          row: 0,
          col: 4
        )
        
        # Test rendering
        begin
          puts "\nTesting Grid Rendering:"
          puts "Expected symbols: # (wall) . (floor) > (stairs) @ (player) M (monster)"
          puts "Current rendering:"
          Draw.map(grid)
          
          # Verify tile symbols
          wall_cell = grid.get(0, 0)
          floor_cell = grid.get(0, 1)
          stairs_cell = grid.get(0, 2)
          player_cell = grid.get(0, 3)
          monster_cell = grid.get(0, 4)
          
          results[:tile_symbols] = {
            wall: wall_cell.to_s,
            floor: floor_cell.to_s,
            stairs: stairs_cell.to_s,
            player: player_cell.to_s,
            monster: monster_cell.to_s
          }
          
        rescue => e
          results[:success] = false
          results[:errors] << {
            error: e.message,
            backtrace: e.backtrace.first(3)
          }
        end
        
        results
      end

      # Test movement in all directions
      #
      # @param world [World] The game world
      # @param player [Entity] The player entity
      # @return [Hash] Test results with success status and error details
      def test_movement(world, player)
        results = { success: true, errors: [] }
        
        # Create a test grid with floor tiles
        grid = MapUtils::Grid.new(3, 3)
        grid.each_cell { |cell| cell.tile = Support::TileType::FLOOR }
        
        # Update player's grid
        player.transform.update_grid(grid)
        player.transform.move_to(1, 1)
        
        # Test movement in each direction
        directions = {
          'h' => [1, 0],  # Left
          'l' => [1, 2],  # Right
          'k' => [0, 1],  # Up
          'j' => [2, 1]   # Down
        }
        
        directions.each do |key, expected_pos|
          initial_pos = player.transform.position.dup
          world.update(key)
          
          if player.transform.position != expected_pos
            results[:success] = false
            results[:errors] << {
              test: "movement_#{key}",
              expected: expected_pos,
              actual: player.transform.position,
              from: initial_pos,
              message: "Movement in direction '#{key}' failed"
            }
          end
          
          # Reset position for next test
          player.transform.move_to(1, 1)
        end
        
        results
      end

      # Test stairs movement and level transition
      #
      # @param world [World] The game world
      # @param player [Entity] The player entity
      # @return [Hash] Test results with success status and error details
      def test_level_transition(world, player)
        results = { success: true, errors: [] }
        
        # Create a test grid with stairs
        grid = MapUtils::Grid.new(3, 3)
        
        # Place stairs next to player
        player_pos = [1, 1]
        stairs_pos = [1, 2]
        
        # Set up the grid
        grid.each_cell { |cell| cell.tile = Support::TileType::FLOOR }  # Initialize all cells as floor
        grid.set(stairs_pos[0], stairs_pos[1], Support::TileType::STAIRS)
        
        # Initialize player's transform component
        transform = Components::TransformComponent.new(player)
        transform.update_grid(grid)
        transform.move_to(player_pos[0], player_pos[1])
        player.add_component(transform)
        
        # Add input system
        world.add_system(Systems::InputSystem.new(world, player))
        
        # Track level transition
        level_transition_occurred = false
        new_grid_id = nil
        
        # Register event handler for level transition
        world.event_manager.on(:level_transition) do |data|
          puts "Level transition event received"
          puts "Old grid ID: #{data[:old_grid].object_id}"
          puts "New grid ID: #{data[:new_grid].object_id}"
          level_transition_occurred = true
          new_grid_id = data[:new_grid].object_id
        end
        
        # Debug output before movement
        puts "\nDebug - Level Transition Test - Before movement:"
        puts "Player position: #{player.transform.position.inspect}"
        puts "Initial grid state (grid_id: #{grid.object_id}):"
        Draw.map(grid)
        
        # Try to move to stairs
        begin
          # First move to stairs
          initial_pos = player.transform.position.dup
          initial_grid = player.transform.grid
          world.update('l') # Move right towards stairs
          
          # Debug output after first movement
          puts "\nDebug - Level Transition Test - After moving to stairs:"
          puts "Player position: #{player.transform.position.inspect}"
          puts "Current cell tile: #{player.transform.current_cell.tile.inspect}"
          puts "Grid state after stairs move:"
          Draw.map(player.transform.grid)
          
          # Store the grid after moving to stairs
          stairs_grid = player.transform.grid
          
          # Now trigger the level transition by moving again
          world.update('l') # Try to move right again to trigger transition
          
          # Debug output after transition
          puts "\nDebug - Level Transition Test - After level transition:"
          puts "Player position: #{player.transform.position.inspect}"
          current_grid = player.transform.grid
          puts "Current grid state (grid_id: #{current_grid.object_id}):"
          Draw.map(current_grid)
          
          # Verify level transition
          if !level_transition_occurred
            results[:success] = false
            results[:errors] << {
              test: "level_transition",
              message: "Level transition event was not triggered",
              debug: {
                initial_grid_id: grid.object_id,
                stairs_grid_id: stairs_grid.object_id,
                current_grid_id: current_grid.object_id,
                player_pos: player.transform.position,
                on_stairs: player.transform.current_cell.tile == Support::TileType::STAIRS,
                current_tile: player.transform.current_cell.tile
              }
            }
          elsif current_grid.object_id != new_grid_id
            results[:success] = false
            results[:errors] << {
              test: "level_transition",
              message: "Grid ID mismatch after level transition",
              debug: {
                initial_grid_id: grid.object_id,
                stairs_grid_id: stairs_grid.object_id,
                current_grid_id: current_grid.object_id,
                new_grid_id: new_grid_id,
                player_pos: player.transform.position,
                on_stairs: player.transform.current_cell.tile == Support::TileType::STAIRS,
                current_tile: player.transform.current_cell.tile
              }
            }
          else
            # Verify the new level is properly initialized
            results[:success] = true
            results[:message] = "Successfully transitioned to new level"
            results[:debug] = {
              old_grid_id: stairs_grid.object_id,
              new_grid_id: current_grid.object_id,
              player_pos: player.transform.position,
              has_stairs: current_grid.each_cell.any? { |cell| cell.tile == Support::TileType::STAIRS }
            }
            puts "\nLevel transition test passed!"
            puts "Old grid ID: #{stairs_grid.object_id}"
            puts "New grid ID: #{current_grid.object_id}"
            puts "Player position: #{player.transform.position.inspect}"
            puts "Has stairs: #{current_grid.each_cell.any? { |cell| cell.tile == Support::TileType::STAIRS }}"
          end
        rescue => e
          results[:success] = false
          results[:errors] << {
            test: "level_transition",
            error: e.message,
            backtrace: e.backtrace.first(3)
          }
        end

        results
      end

      # Safely attempts to load the game and returns either the game state or error information
      #
      # @return [Hash] Either:
      #   - A successful game state from verify_game_state
      #   - An error hash containing:
      #     - :error [Exception] The caught exception
      #     - :message [String] The error message
      #     - :backtrace [Array] First 5 lines of the error backtrace
      def load_game
        require_relative '../vanilla'
        state = verify_game_state
        
        # Test grid rendering first
        render_test = test_grid_rendering
        unless render_test[:success]
          return {
            error: RuntimeError.new("Grid rendering test failed"),
            message: "Grid rendering errors detected",
            details: render_test[:errors],
            tile_symbols: render_test[:tile_symbols]
          }
        end
        
        # Test movement functionality
        movement_test = test_movement(state[:world], state[:player])
        unless movement_test[:success]
          return {
            error: RuntimeError.new("Movement test failed"),
            message: "Movement system errors detected",
            details: movement_test[:errors]
          }
        end

        # Test level transition
        level_test = test_level_transition(state[:world], state[:player])
        unless level_test[:success]
          return {
            error: RuntimeError.new("Level transition test failed"),
            message: "Level transition errors detected",
            details: level_test[:errors]
          }
        end
        
        state
      rescue => e
        {
          error: e,
          message: e.message,
          backtrace: e.backtrace.first(5)
        }
      end

      def self.test_level_transition
        begin
          puts "Starting test_level_transition..."
          
          # Create a 3x3 grid for testing
          grid = MapUtils::Grid.new(3, 3)
          puts "Created grid: #{grid.object_id}"
          
          # Initialize grid with floor tiles
          grid.each_cell do |cell|
            cell.tile = Support::TileType::FLOOR
          end
          puts "Initialized grid with floor tiles"
          
          # Place stairs at [1, 2]
          stairs_cell = grid.get(1, 2)
          stairs_cell.tile = Support::TileType::STAIRS
          puts "Placed stairs at [1, 2]"
          
          # Create a world instance
          world = World.new
          puts "Created world"
          
          # Create a player entity with transform component
          player = Entity.new
          transform = Components::TransformComponent.new(grid, [1, 1])
          player.add_component(transform)
          world.add_entity(player)
          puts "Created player entity with transform component"
          
          # Add input system
          input_system = Systems::InputSystem.new
          world.add_system(input_system)
          puts "Added input system"
          
          # Track level transition
          transition_occurred = false
          old_grid_id = grid.object_id
          new_grid_id = nil
          
          # Register event handler for level transition
          Events::EventManager.on(:level_transition) do |data|
            puts "Level transition event received"
            transition_occurred = true
            new_grid_id = data[:new_grid].object_id
            puts "New grid ID: #{new_grid_id}"
          end
          puts "Registered level transition event handler"
          
          puts "\nInitial grid state:"
          puts grid.to_s
          puts "Player position: #{transform.position.inspect}"
          
          # Move player to stairs
          puts "\nMoving player to stairs..."
          movement = Commands::MovementCommand.new(player, [0, 1])
          result = movement.execute
          puts "Movement command created and executed"
          
          puts "\nAfter movement:"
          puts transform.grid.to_s
          puts "Player position: #{transform.position.inspect}"
          puts "Movement result: #{result}"
          puts "Transition occurred: #{transition_occurred}"
          puts "Old grid ID: #{old_grid_id}"
          puts "New grid ID: #{new_grid_id}"
          
          # Verify level transition
          if !transition_occurred
            raise "Level transition did not occur"
          end
          
          if old_grid_id == new_grid_id
            raise "Grid was not changed during transition"
          end
          
          # Return success
          { success: true }
        rescue StandardError => e
          puts "\nError occurred: #{e.message}"
          puts e.backtrace
          { success: false, error: e.message }
        end
      end
    end
  end
end 