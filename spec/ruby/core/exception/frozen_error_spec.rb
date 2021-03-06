require_relative '../../spec_helper'

describe "FrozenError.new" do
  it "should take optional receiver argument" do
    o = Object.new
    FrozenError.new("msg", receiver: o).receiver.should equal(o)
  end
end

describe "FrozenError#receiver" do
  it "should return frozen object that modification was attempted on" do
    o = Object.new.freeze
    begin
      def o.x; end
    rescue => e
      e.should be_kind_of(FrozenError)
      e.receiver.should equal(o)
    else
      raise
    end
  end
end
