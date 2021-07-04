require 'spec_helper'

RSpec.describe Vanilla::Demo do
  describe '.run' do
    it { expect { described_class.run(testing: true) }.not_to raise_error }
  end
end
