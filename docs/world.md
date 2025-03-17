# World Class Documentation

## Overview
The `World` class is the central orchestrator of the Entity Component System (ECS) architecture. It serves as the container and manager for all game entities, systems, and their interactions. Think of it as the "universe" in which all game elements exist and operate.

## Core Responsibilities

### 1. Entity Management
```ruby
attr_reader :entities
@entities = Set.new
@to_add = []
@to_remove = []
```

- **Purpose**: Maintains the collection of all game entities
- **Implementation**: Uses a Set for unique entity storage
- **Deferred Operations**: Uses separate queues (@to_add, @to_remove) for safe entity addition/removal
- **Why**: Prevents mutation of entities collection during iteration

### 2. System Management
```ruby
attr_reader :systems
@systems = []
```

- **Purpose**: Coordinates all game systems
- **Order**: Systems are processed in the order they're added
- **Responsibility**: Each system operates on entities with specific components
- **Why**: Separates concerns and allows modular game logic

### 3. Event Management
```ruby
attr_reader :event_manager
@event_manager = Events::EventManager.new
```

- **Purpose**: Facilitates communication between systems
- **Implementation**: Pub/sub pattern for event distribution
- **Why**: Decouples systems and enables reactive game behavior

## Key Methods

### Entity Management
```ruby
def add_entity(entity)
  @to_add << entity
end

def remove_entity(entity)
  @to_remove << entity
end
```

- **Purpose**: Safe entity lifecycle management
- **Why Deferred**: 
  - Prevents concurrent modification issues
  - Allows systems to mark entities for removal safely
  - Maintains data consistency during update cycle

### System Management
```ruby
def add_system(system)
  @systems << system
end
```

- **Purpose**: Registers systems for processing
- **Order Matters**: Systems are processed in registration order
- **Why**: Allows control over game logic execution sequence

### Update Cycle
```ruby
def update(delta_time)
  # Process pending entity changes
  @to_add.each { |entity| @entities.add(entity) }
  @to_remove.each { |entity| @entities.delete(entity) }
  @to_add.clear
  @to_remove.clear

  # Update all systems
  @systems.each { |system| system.update(delta_time) }
end
```

- **Purpose**: Main game loop orchestration
- **Sequence**:
  1. Process pending entity changes
  2. Clear change queues
  3. Update each system
- **Why Delta Time**: Ensures consistent game speed regardless of frame rate

### Entity Queries
```ruby
def entities_with_components(*component_classes)
  @entities.select do |entity|
    component_classes.all? { |klass| entity.has_component?(klass) }
  end
end
```

- **Purpose**: Efficient entity filtering
- **Usage**: Systems use this to find relevant entities
- **Why**: Optimizes processing by only considering entities with required components

## Design Principles

### 1. Single Responsibility
- World class focuses solely on managing game elements
- Delegates actual game logic to systems
- Maintains clear boundaries between concerns

### 2. Data-Oriented Design
- Entities are just data containers
- Systems contain behavior
- Clear separation of data and behavior

### 3. Safe Concurrency
- Deferred entity modifications
- Predictable update order
- Thread-safe event handling

### 4. Flexibility
- Easy to add/remove systems
- Dynamic entity composition
- Extensible event system

## Usage Examples

### Basic Setup
```ruby
world = World.new
world.add_system(MovementSystem.new(world))
world.add_system(CombatSystem.new(world))
world.add_system(RenderSystem.new(world))
```

### Entity Lifecycle
```ruby
player = Entity.new
player.add_component(TransformComponent.new)
world.add_entity(player)  # Queued for next update
```

### System Updates
```ruby
game_loop do
  delta_time = calculate_delta
  world.update(delta_time)
end
```

## Integration with Command Pattern

### Command Processing
- Commands can query the world for relevant entities
- Commands can trigger world events
- Systems can react to command events

### Example
```ruby
class MoveCommand
  def execute(world)
    entities = world.entities_with_components(MovementComponent)
    # Process movement
    world.event_manager.trigger(:movement_completed)
  end
end
```

## Best Practices

1. **Entity Management**
   - Always use add_entity/remove_entity methods
   - Never modify @entities directly
   - Consider entity pooling for performance

2. **System Order**
   - Add systems in logical processing order
   - Consider dependencies between systems
   - Document system requirements

3. **Event Usage**
   - Use events for cross-system communication
   - Keep events focused and specific
   - Document event contracts

4. **Performance Considerations**
   - Cache component queries when possible
   - Use appropriate data structures
   - Profile system updates

## Common Pitfalls

1. **Direct Entity Modification**
   - Problem: Modifying @entities during iteration
   - Solution: Use deferred add/remove queues

2. **System Ordering**
   - Problem: Systems dependent on each other's updates
   - Solution: Carefully order system registration

3. **Event Overuse**
   - Problem: Too many events causing performance issues
   - Solution: Use events judiciously, batch when possible

## Testing Strategies

1. **Unit Tests**
   - Test entity management
   - Test system registration
   - Test event dispatching

2. **Integration Tests**
   - Test system interactions
   - Test entity lifecycle
   - Test event chains

3. **Performance Tests**
   - Test with many entities
   - Test system update times
   - Test event handling scaling 

## What World Does NOT Do

### 1. Game Logic
- Does NOT implement game rules
- Does NOT make gameplay decisions
- Does NOT handle specific game mechanics
- Does NOT determine win/loss conditions

### 2. Component Management
- Does NOT modify component data
- Does NOT validate component data
- Does NOT handle component dependencies
- Does NOT manage component lifecycle

### 3. System Implementation
- Does NOT implement system-specific logic
- Does NOT determine system execution details
- Does NOT resolve system conflicts
- Does NOT optimize system performance

### 4. Resource Management
- Does NOT load/unload resources
- Does NOT manage memory allocation
- Does NOT handle asset loading
- Does NOT manage file I/O

### 5. Input Handling
- Does NOT process user input
- Does NOT handle input mapping
- Does NOT manage input states
- Does NOT implement input validation

### 6. Rendering
- Does NOT handle rendering logic
- Does NOT manage display output
- Does NOT control visual effects
- Does NOT handle UI layout

### 7. State Management
- Does NOT maintain game state
- Does NOT handle save/load operations
- Does NOT manage game progression
- Does NOT track achievement/statistics

### 8. Error Handling
- Does NOT catch system-specific errors
- Does NOT implement error recovery
- Does NOT log errors
- Does NOT handle exception reporting

## Limitations

### 1. Performance Boundaries
- No built-in entity pooling
- Linear component querying
- No automatic system optimization
- Basic event dispatching

### 2. Architectural Constraints
- Single-threaded execution model
- Synchronous system updates
- No built-in spatial partitioning
- Limited entity hierarchies

### 3. Scalability Limits
- No automatic load balancing
- No built-in sharding capability
- Memory grows with entity count
- Event processing is sequential

### 4. Integration Boundaries
- No direct rendering pipeline integration
- No built-in networking support
- No automatic state serialization
- No direct physics engine integration

## Responsibilities That Belong Elsewhere

### 1. Game-Specific Logic
```ruby
# DON'T do this in World:
def update(delta_time)
  check_win_condition    # Wrong! Belongs in a GameStateSystem
  update_score          # Wrong! Belongs in a ScoreSystem
  handle_player_input   # Wrong! Belongs in an InputSystem
end
```

### 2. Component Logic
```ruby
# DON'T do this in World:
def add_entity(entity)
  validate_components(entity)     # Wrong! Components self-validate
  initialize_component_data(entity) # Wrong! Components self-initialize
  @to_add << entity              # Correct! Just manage the entity
end
```

### 3. System-Specific Operations
```ruby
# DON'T do this in World:
def update(delta_time)
  handle_collisions           # Wrong! Belongs in CollisionSystem
  update_animations          # Wrong! Belongs in AnimationSystem
  process_ai                # Wrong! Belongs in AISystem
  @systems.each(&:update)   # Correct! Just coordinate systems
end
```

### 4. Direct Resource Access
```ruby
# DON'T do this in World:
def initialize
  @textures = load_textures    # Wrong! Use a ResourceSystem
  @sounds = load_sounds        # Wrong! Use an AudioSystem
  @entities = Set.new          # Correct! Just manage entities
end
```

## Delegation Examples

### 1. Proper Delegation of Responsibilities
```ruby
# World coordinates but doesn't implement
class World
  def update(delta_time)
    process_entity_changes     # Correct: Entity management
    @systems.each do |system|  # Correct: System coordination
      system.update(delta_time)
    end
    @event_manager.process    # Correct: Event coordination
  end
end

# Specific logic belongs in systems
class GameStateSystem < BaseSystem
  def update(delta_time)
    check_win_condition       # Game logic here
    update_score             # Game state here
  end
end
```

### 2. Proper Event Usage
```ruby
# World manages event flow but doesn't handle specifics
class World
  def handle_collision(entity1, entity2)
    # Wrong: Don't process collision here
    # @physics.resolve_collision(entity1, entity2)
    
    # Correct: Just emit the event
    @event_manager.trigger(:collision, entity1, entity2)
  end
end
```

Remember: The World class is a coordinator, not an implementer. It provides the structure and flow for other components to operate within, but does not implement specific game mechanics or behaviors. 