require_relative 'grid'

module Vanilla
  class DistanceGrid < Grid
    attr_accessor :distances

    # Note that because we’re limited to one ASCII character for the body of the cell,
    # we format the distance as a base-36 integer.
    # That is to say, numbers from 0 to 9 are represented as usual, but when we reach a decimal number 10,
    # we switch to letters.
    # The number 10 is a, 11 is b, 12 is c, and so forth, all the way to z for 35.
    # The number 36, then, becomes a 10, and the one’s place starts all over again.
    # This lets us represent distances up to 35 using a single character.
    def contents_of(cell)
      if distances && distances[cell]
        distances[cell].to_s(36)
      else
        super
      end
    end
  end
end
