require 'spec_helper'

describe Isomer::Sources::Base do
  describe '#get' do
    it 'raises a NotImplementedError' do
      source = Isomer::Sources::Base.new
      expect {
        source.get(anything)
      }.to raise_error(NotImplementedError, "You must implement 'get' in Isomer::Sources::Base")
    end
  end
end
