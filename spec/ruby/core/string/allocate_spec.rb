require_relative '../../spec_helper'

describe "String.allocate" do
  it "returns an instance of String" do
    str = String.allocate
    str.should be_an_instance_of(String)
  end

  it "returns a fully-formed String" do
    str = String.allocate
    str.size.should == 0
    str << "more"
    str.should == "more"
  end

  it "returns a binary String" do
    String.allocate.encoding.should == Encoding::BINARY
  end
end
