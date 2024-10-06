module Vanilla
  module Demo

    # Simulates user input to showcase the capabilities of the engine
    # To be use only for demonstrations, this is a predefined environment
    def self.run(testing: false)
      duration = testing ? 0.1 : 0.4

      grid   = Vanilla::Map.create(rows: 10, columns: 10, seed: 84625887428918)
      player = Characters::Player.new(row: 9, column: 3)

      Vanilla::Draw.player(grid: grid, unit: player)
      Vanilla::Draw.stairs(grid: grid, row: 9, column: 0)

      sleep(duration * 2.2)

      1.upto(5) { Vanilla::Draw.movement(grid: grid, unit: player, direction: :right); sleep(duration) }
      Vanilla::Draw.movement(grid: grid, unit: player, direction: :up) ; sleep(duration)
      Vanilla::Draw.movement(grid: grid, unit: player, direction: :right) ; sleep(duration)

      1.upto(8) { Vanilla::Draw.movement(grid: grid, unit: player, direction: :up) ; sleep(duration) }
      1.upto(3) { Vanilla::Draw.movement(grid: grid, unit: player, direction: :left) ; sleep(duration) }

      1.upto(2) do
        Vanilla::Draw.movement(grid: grid, unit: player, direction: :down) ; sleep(duration)
        Vanilla::Draw.movement(grid: grid, unit: player, direction: :left) ; sleep(duration)
      end

      1.upto(2) { Vanilla::Draw.movement(grid: grid, unit: player, direction: :down) ; sleep(duration) }

      Vanilla::Draw.movement(grid: grid, unit: player, direction: :left) ; sleep(duration)

      1.upto(4) { Vanilla::Draw.movement(grid: grid, unit: player, direction: :down) ; sleep(duration) }

      Vanilla::Draw.movement(grid: grid, unit: player, direction: :left) ; sleep(duration)
      Vanilla::Draw.movement(grid: grid, unit: player, direction: :down) ; sleep(duration)

      Vanilla::Draw.movement(grid: grid, unit: player, direction: :left) ; sleep(duration)
      Vanilla::Draw.movement(grid: grid, unit: player, direction: :left) ; sleep(duration)

      # Simulate new level
      grid = Vanilla::Map.create(rows: 10, columns: 10, seed: 289665986641610);
      Vanilla::Draw.player(grid: grid, unit: player)
      Vanilla::Draw.stairs(grid: grid, row: 9, column: 6)
    end
  end
end
