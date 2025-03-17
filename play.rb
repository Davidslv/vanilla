require_relative 'lib/vanilla'
require 'io/console'

begin
  puts "Initializing game..."
  
  # Initialize the game world
  world = Vanilla::World.new
  puts "✓ World created"

  # Create a grid with a proper maze
  puts "Generating maze..."
  grid = Vanilla::Map.create(
    rows: 10,
    columns: 10,
    algorithm: Vanilla::Algorithms::PathFirst,
    seed: rand(999_999_999_999_999)
  )
  puts "✓ Maze generated"

  # Test grid state
  puts "\nGrid state:"
  puts "- Rows: #{grid.rows}"
  puts "- Columns: #{grid.cols}"
  puts "- Sample cells:"
  puts "  - (0,0): #{grid.cell_at(0, 0).tile}"
  puts "  - (1,1): #{grid.cell_at(1, 1).tile}"
  
  # Create the player entity
  puts "\nCreating player..."
  player = Vanilla::Characters::Player.new(
    grid: grid,
    row: 1,
    col: 1
  )
  world.add_entity(player)
  puts "✓ Player created at position #{player.position.inspect}"

  # Create terminal for display
  puts "Initializing terminal..."
  terminal = Vanilla::Output::Terminal.new(grid: grid, player: player)
  puts "✓ Terminal initialized"

  # Add systems to the world
  puts "Adding game systems..."
  world.add_system(Vanilla::Systems::InputSystem.new(world, player))
  world.add_system(Vanilla::Systems::MessageSystem.new(world))
  puts "✓ Systems added"

  puts "\nStarting game loop..."
  puts "Initial grid state:"
  puts "-" * 20
  Vanilla::Draw.map(grid)
  puts "-" * 20

  # Game loop
  loop do
    # Get input
    input = STDIN.getch

    # Exit on 'q'
    break if input == 'q'

    # Update world with input
    world.update(input)

    # Clear screen and redraw
    system('clear') || system('cls')

    # Draw the grid
    Vanilla::Draw.map(grid)

    # Draw game state
    puts "\nPlayer position: #{player.position.inspect}"
    puts "Health: #{player.stats.health}/#{player.stats.max_health}"
    puts "Level: #{player.stats.level} (#{player.stats.experience}/#{player.stats.next_level_exp} XP)"
    puts "\nControls:"
    puts "h - move left"
    puts "l - move right"
    puts "k - move up"
    puts "j - move down"
    puts "q - quit"
  end

rescue => e
  puts "\nError during game initialization:"
  puts "#{e.class}: #{e.message}"
  puts "Backtrace:"
  puts e.backtrace[0..5]
end