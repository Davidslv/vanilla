module Vanilla
  module Algorithms
    class AbstractAlgorithm
      def self.demodulize
        self.name.split('::').last
      end
    end
  end
end
