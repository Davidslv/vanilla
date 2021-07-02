module Vanilla
  module Demo
    $current_position = [9, 3]

    def self.run
      duration = 0.4

      grid = Vanilla.create_grid(rows: 10, columns: 10, seed: 84625887428918);
      Vanilla::Draw.player(grid: grid, row: 9, column: 3)
      Vanilla::Draw.stairs(grid: grid, row: 9, column: 0)

      sleep(duration * 2.2)

      1.upto(5) { Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :right); sleep(duration) }
      Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :up) ; sleep(duration)
      Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :right) ; sleep(duration)

      1.upto(8) { Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :up) ; sleep(duration) }
      1.upto(3) { Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :left) ; sleep(duration) }

      1.upto(2) do
        Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :down) ; sleep(duration)
        Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :left) ; sleep(duration)
      end

      1.upto(2) { Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :down) ; sleep(duration) }

      Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :left) ; sleep(duration)

      1.upto(4) { Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :down) ; sleep(duration) }

      Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :left) ; sleep(duration)
      Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :down) ; sleep(duration)

      Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :left) ; sleep(duration)
      Vanilla::Draw.movement(grid: grid, coordinates: $current_position, direction: :left) ; sleep(duration)

      # Simulate new level

      grid = Vanilla.create_grid(rows: 10, columns: 10, seed: 289665986641610);
      Vanilla::Draw.player(grid: grid, row: 9, column: 0)
      Vanilla::Draw.stairs(grid: grid, row: 9, column: 6)
    end
  end
end
