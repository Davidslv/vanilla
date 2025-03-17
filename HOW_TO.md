# How To Guide

## Setup

### Prerequisites
- Ruby 2.7 or higher
- Bundler

### Installation
1. Clone the repository
```bash
git clone <repository_url>
cd vanilla
```

2. Install dependencies
```bash
bundle install
```

## Running Tests

### Unit Tests
Run all unit tests:
```bash
bundle exec rspec
```

Run specific test file:
```bash
bundle exec rspec spec/lib/vanilla/components/transform_component_spec.rb
```

Run specific test:
```bash
bundle exec rspec spec/lib/vanilla/components/transform_component_spec.rb:42
```

### Integration Tests
Run integration tests:
```bash
bundle exec rspec spec/integration
```

### Debug Tests
Run debug test suite:
```bash
ruby lib/vanilla/debug.rb
```

## Development

### Running the Game
```bash
ruby play.rb
```

### Controls
- `h` - Move left
- `l` - Move right
- `j` - Move down
- `k` - Move up
- `q` - Quit game

### Debug Mode
To run with debug output:
```bash
DEBUG=1 ruby play.rb
```

## Testing Strategy

### 1. Unit Tests
- Test individual components in isolation
- Verify component initialization
- Check component state management
- Test component interactions

### 2. Integration Tests
- Test system interactions
- Verify event handling
- Check level transitions
- Test player movement

### 3. Debug Tests
- Test specific game scenarios
- Verify grid state
- Check level generation
- Test player positioning

## Common Issues

### 1. Level Transition
If the player disappears during level transition:
1. Check grid state before transition
2. Verify player position after transition
3. Ensure event handlers are registered

### 2. Event Handling
If events are not firing:
1. Verify event manager initialization
2. Check event registration
3. Ensure proper event emission

## Contributing

### 1. Making Changes
1. Create a feature branch
2. Make changes in logical commits
3. Add tests for new functionality
4. Update documentation

### 2. Commit Messages
Follow this format:
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- test: Adding tests
- refactor: Code refactoring

Example:
```
fix(transform): handle player position during level transition

- Add position preservation during grid update
- Fix tile type management
- Add tests for grid transition

Fixes #123
``` 