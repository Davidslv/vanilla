# Component Pattern Implementation Plan

## 1. Base Component System

```ruby
module Vanilla
  class Component
    attr_reader :entity

    def initialize(entity)
      @entity = entity
    end

    def update
      # Optional: Override in specific components if they need per-tick updates
    end
  end

  class Entity
    def initialize
      @components = {}
    end

    def add_component(component_class)
      component = component_class.new(self)
      @components[component_class] = component
    end

    def get_component(component_class)
      @components[component_class]
    end

    def has_component?(component_class)
      @components.key?(component_class)
    end
  end
end
```

## 2. Core Components

### TransformComponent
Handles position and grid placement:
```ruby
class TransformComponent < Component
  attr_accessor :row, :column, :grid

  def initialize(entity, grid, row = 0, column = 0)
    super(entity)
    @grid = grid
    @row = row
    @column = column
  end

  def move_to(new_row, new_column)
    return false unless valid_position?(new_row, new_column)
    
    @grid.clear(@row, @column)
    @row = new_row
    @column = new_column
    @grid.place(entity, @row, @column)
    true
  end

  private

  def valid_position?(row, column)
    @grid.within_bounds?(row, column)
  end
end
```

### StatsComponent
Manages character statistics:
```ruby
class StatsComponent < Component
  attr_accessor :health, :max_health, :attack, :defense, :level, :experience

  def initialize(entity, stats = {})
    super(entity)
    @health = stats[:health] || 100
    @max_health = stats[:max_health] || 100
    @attack = stats[:attack] || 10
    @defense = stats[:defense] || 5
    @level = stats[:level] || 1
    @experience = stats[:experience] || 0
  end

  def alive?
    @health > 0
  end

  def take_damage(amount)
    @health = [@health - amount, 0].max
  end
end
```

### MovementComponent
Handles movement logic:
```ruby
class MovementComponent < Component
  def move(direction)
    transform = entity.get_component(TransformComponent)
    return false unless transform

    new_row = transform.row + direction_to_offset(direction)[0]
    new_column = transform.column + direction_to_offset(direction)[1]
    
    transform.move_to(new_row, new_column)
  end

  private

  def direction_to_offset(direction)
    {
      north: [-1, 0],
      south: [1, 0],
      east: [0, 1],
      west: [0, -1]
    }[direction]
  end
end
```

### CombatComponent
Manages combat interactions:
```ruby
class CombatComponent < Component
  def attack(target)
    return false unless can_attack?(target)

    attacker_stats = entity.get_component(StatsComponent)
    target_stats = target.get_component(StatsComponent)
    
    damage = calculate_damage(attacker_stats.attack, target_stats.defense)
    target_stats.take_damage(damage)
    
    true
  end

  private

  def can_attack?(target)
    target.has_component?(StatsComponent)
  end

  def calculate_damage(attack, defense)
    [attack - defense, 1].max
  end
end
```

## 3. Refactored Unit Class
```ruby
module Vanilla
  class Unit < Entity
    def initialize(grid, row, column)
      super()
      add_component(TransformComponent).setup(grid, row, column)
      add_component(StatsComponent)
      add_component(MovementComponent)
      add_component(CombatComponent)
    end
  end
end
```

## 4. Migration Plan

1. Create base Component and Entity classes
2. Implement core components one at a time:
   - Start with TransformComponent (position management)
   - Add StatsComponent (health, attack, etc.)
   - Add MovementComponent (movement logic)
   - Add CombatComponent (combat interactions)

3. Update Unit class to use components
4. Update Player and Monster classes to extend functionality through components
5. Update existing game logic to work with component system
6. Add tests for each component

## Benefits

1. **Modularity**: Each component handles one specific aspect
2. **Reusability**: Components can be mixed and matched
3. **Testability**: Components can be tested in isolation
4. **Flexibility**: Easy to add new features by adding components
5. **Maintainability**: Simpler to modify individual behaviors

## Example Usage

```ruby
# Creating a new player
player = Player.new(grid, 1, 1)

# Moving the player
movement = player.get_component(MovementComponent)
movement.move(:north)

# Combat interaction
combat = player.get_component(CombatComponent)
combat.attack(monster)

# Checking player stats
stats = player.get_component(StatsComponent)
puts "Health: #{stats.health}/#{stats.max_health}"
``` 