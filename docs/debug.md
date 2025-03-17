# Debugging Tools and Mechanisms

## Overview
The Vanilla game engine provides a robust debugging system that helps developers quickly verify game state, catch errors, and inspect components during development.

## Available Tools

### 1. Debug Module (`lib/vanilla/debug.rb`)
The core debugging functionality is provided by `Vanilla::Debug` module with two main methods:

- `verify_game_state`: Creates a minimal test environment with:
  - A 3x3 grid
  - A new world instance
  - A player entity at position (1,1)
  - Returns a hash containing the world, grid, player and current status

- `load_game`: Safe wrapper around game initialization that:
  - Attempts to load the game
  - Catches and formats any errors
  - Returns either game state or error information

### 2. Development Script (`bin/dev`)
A command-line tool that provides immediate feedback about:
- Game loading status
- Player position
- Active components
- Running systems
- Detailed error messages if something goes wrong

## Usage Examples

### Quick State Check
```ruby
./bin/dev
```

### Interactive Debugging
```ruby
pry -r ./lib/vanilla/debug

# Get current state
state = Vanilla::Debug.verify_game_state

# Inspect specific aspects
state[:player].position
state[:world].systems

# Check component status
state[:status][:components]
```

### Error Handling
The debug system captures and formats errors with:
- Error message
- Error type
- First 5 lines of backtrace
- Context about where the error occurred

## Best Practices

1. **Regular State Verification**
   - Run `./bin/dev` after making changes
   - Check if systems and components are loaded correctly

2. **Interactive Debugging**
   - Use `pry` for deep inspection of game state
   - Modify state during runtime for testing

3. **Error Investigation**
   - Review error messages and stack traces
   - Use the context provided to locate issues

4. **Component Testing**
   - Verify component loading
   - Check system interactions
   - Validate entity states

## Event Debugging

The `EventManager` provides ways to debug event flow:

1. **Event Listening**
   ```ruby
   world.event_manager.on(:movement_completed) do |data|
     puts "Movement completed: #{data}"
   end
   ```

2. **Event Triggering**
   ```ruby
   world.event_manager.trigger(:movement_completed, {
     entity: player,
     from: [0,0],
     to: [0,1]
   })
   ```

## Common Debug Scenarios

1. **Missing Components**
   - Check `state[:status][:components]`
   - Verify component initialization

2. **System Failures**
   - Review `state[:status][:systems]`
   - Check system dependencies

3. **Event Issues**
   - Add debug listeners to track event flow
   - Verify event data structure 