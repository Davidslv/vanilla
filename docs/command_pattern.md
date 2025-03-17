# Command Pattern Implementation and System Architecture

## Overview

This document describes the implementation of the Command pattern and system architecture in our game. The architecture is built around three main concepts:

1. Commands - Encapsulate actions that can be performed in the game
2. Systems - Process game logic and manage specific aspects of gameplay
3. World - Coordinates entities, systems, and their interactions

## Command Pattern

### Base Command

All commands inherit from `BaseCommand`, which provides common functionality:

```ruby
class BaseCommand
  def initialize(world:, entity:)
    @world = world
    @entity = entity
  end

  def can_execute?
    true  # Override in subclasses
  end

  def execute
    raise NotImplementedError
  end

  protected

  def emit_event(event_name, **data)
    @world.event_manager.trigger(event_name, data)
  end

  def get_component(component_class)
    @entity.get_component(component_class)
  end
end
```

### Movement Command

The `MovementCommand` handles entity movement:

- **Responsibilities**:
  - Validate movement possibility
  - Update entity position
  - Handle special tile interactions (stairs, monsters)
  - Emit movement-related events

- **Key Methods**:
  ```ruby
  def can_execute?
    # Checks if:
    # - Movement is within grid bounds
    # - Target cell is linked (passable)
  end

  def execute
    # - Moves entity if possible
    # - Handles special tiles
    # - Emits appropriate events
  end
  ```

### Combat Command

The `CombatCommand` manages combat interactions:

- **Responsibilities**:
  - Validate combat possibility
  - Calculate and apply damage
  - Handle target defeat
  - Award experience
  - Update game state

- **Key Methods**:
  ```ruby
  def can_execute?
    # Checks if:
    # - Entities have required components
    # - Entities are adjacent
    # - Target is alive
  end

  def execute
    # - Calculates and applies damage
    # - Handles target death if applicable
    # - Awards experience
    # - Emits combat events
  end
  ```

## Systems

### Input System

Manages player input and command creation:

- **Responsibilities**:
  - Process keyboard input
  - Create appropriate commands
  - Manage command queue
  - Execute commands

- **Key Methods**:
  ```ruby
  def process_input(key)
    # Maps keys to commands:
    # h -> move left
    # j -> move down
    # k -> move up
    # l -> move right
    # q -> quit game
  end

  def update
    # Executes queued commands
    # Handles command results
  end
  ```

### Message System

Handles game messages and notifications:

- **Responsibilities**:
  - Listen to game events
  - Generate appropriate messages
  - Maintain message history
  - Provide message access

- **Event Handlers**:
  - Movement events (completion, wall hits)
  - Combat events (initiation, execution, results)
  - Stairs events
  - Command events (invalid, failed)

## World Class

The central coordinator for the game:

- **Responsibilities**:
  - Manage entities and systems
  - Process input
  - Update game state
  - Handle messages
  - Coordinate component queries

- **Key Methods**:
  ```ruby
  def add_entity(entity)
  def remove_entity(entity)
  def add_system(system)
  def update
  def process_input(key)
  def messages
  def clear_messages
  def entities_with_components(*component_classes)
  ```

## Event System

Events are used for communication between components:

### Movement Events
- `:movement_completed` - Entity moved successfully
- `:hit_wall` - Entity attempted to move through wall
- `:stairs_found` - Entity found stairs

### Combat Events
- `:combat_initiated` - Combat begins
- `:combat_executed` - Attack performed
- `:target_survived` - Target survives attack
- `:target_defeated` - Target is defeated
- `:experience_gained` - Experience awarded

### Command Events
- `:invalid_command` - Invalid input received
- `:command_failed` - Command couldn't be executed
- `:message_added` - New message added to system

## Component System

### Base Component

All components inherit from `BaseComponent`, which provides core functionality:

```ruby
class BaseComponent
  attr_accessor :entity

  def initialize(entity)
    @entity = entity
  end

  def update
    # Optional: Override in specific components
  end
end
```

### Component Management

Entities manage their components through a set of methods with built-in error handling:

```ruby
def add_component(component)
  validate_component(component)
  component.entity = self
  @components[component.class] = component
end

def remove_component(component)
  validate_component(component)
  @components.delete(component.class)
end

def get_component(component_class)
  raise ComponentError if component_class.nil?
  @components[component_class]
end
```

### Error Handling

The component system includes robust error handling:

1. **Component Validation**
   - Components must inherit from `BaseComponent`
   - Nil components are rejected
   - Component class must be specified for queries

2. **Error Types**
   ```ruby
   class ComponentError < StandardError; end
   ```

3. **Common Error Cases**
   - Adding nil component
   - Adding invalid component type
   - Querying with nil component class
   - Removing non-existent component

### Component Lifecycle

1. **Creation**
   ```ruby
   component = MyComponent.new(entity)
   entity.add_component(component)
   ```

2. **Access**
   ```ruby
   component = entity.get_component(MyComponent)
   ```

3. **Update**
   ```ruby
   entity.update  # Updates all components
   ```

4. **Removal**
   ```ruby
   entity.remove_component(component)
   ```

### Best Practices

1. **Component Design**
   - Keep components focused and single-purpose
   - Use composition over inheritance
   - Implement `update` only when needed

2. **Error Handling**
   - Always check component existence before use
   - Handle component errors at appropriate levels
   - Use meaningful error messages

3. **Testing**
   - Test component lifecycle
   - Verify error conditions
   - Check component interactions

## Testing

The architecture is thoroughly tested:

### Command Tests
- Validation of movement and combat conditions
- Event emission verification
- State changes confirmation
- Edge case handling

### System Tests
- Input processing verification
- Message handling confirmation
- System state management
- Event handling coverage

### World Tests
- Entity management
- System coordination
- Input delegation
- Message management

## Integration Example

Here's how the components work together:

1. Player presses 'h' key
2. Input System:
   - Creates MovementCommand
   - Adds to command queue
3. World updates:
   - Input System executes command
   - Movement validated and performed
   - Events emitted
4. Message System:
   - Receives events
   - Generates appropriate messages
5. World provides messages for display

## Best Practices

1. **Command Creation**
   - Always validate before execution
   - Use meaningful event names
   - Keep commands focused and single-purpose

2. **System Design**
   - Clear separation of concerns
   - Event-driven communication
   - Minimal direct dependencies

3. **Testing**
   - Test each component in isolation
   - Verify event emissions
   - Check edge cases
   - Test integration points

## Limitations and Considerations

1. **Performance**
   - Command queue processing is synchronous
   - Event handling can cascade
   - Component queries are linear time

2. **Extensibility**
   - New commands can be added easily
   - Systems can be registered dynamically
   - Event handlers are loosely coupled

3. **Maintainability**
   - Clear separation of concerns
   - Well-defined interfaces
   - Comprehensive test coverage 