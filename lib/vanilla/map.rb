module Vanilla
  class Map
    def initialize(rows: 10, columns: 10, algorithm:, seed: nil)
      $seed = seed || rand(999_999_999_999_999)
      srand($seed)

      @rows, @columns, @algorithm = rows, columns, algorithm
    end

    def self.create(rows:, columns:, algorithm: Vanilla::Algorithms::BinaryTree, seed:)
      new(rows: rows, columns: columns, algorithm: algorithm, seed: seed).create
    end

    def create
      grid = Vanilla::MapUtils::Grid.new(rows: @rows, columns: @columns)
      @algorithm.on(grid)

      grid.dead_ends
      grid
    end
  end
end
