require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#shift" do
  it "removes and returns the first element" do
    a = [5, 1, 1, 5, 4]
    a.shift.should == 5
    a.should == [1, 1, 5, 4]
    a.shift.should == 1
    a.should == [1, 5, 4]
    a.shift.should == 1
    a.should == [5, 4]
    a.shift.should == 5
    a.should == [4]
    a.shift.should == 4
    a.should == []
  end

  it "returns nil when the array is empty" do
    [].shift.should == nil
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty.shift.should == []
    empty.should == []

    array = ArraySpecs.recursive_array
    array.shift.should == 1
    array[0..2].should == ['two', 3.0, array]
  end

  it "raises a FrozenError on a frozen array" do
    -> { ArraySpecs.frozen_array.shift }.should raise_error(FrozenError)
  end
  it "raises a FrozenError on an empty frozen array" do
    -> { ArraySpecs.empty_frozen_array.shift }.should raise_error(FrozenError)
  end

  describe "passed a number n as an argument" do
    it "removes and returns an array with the first n element of the array" do
      a = [1, 2, 3, 4, 5, 6]

      a.shift(0).should == []
      a.should == [1, 2, 3, 4, 5, 6]

      a.shift(1).should == [1]
      a.should == [2, 3, 4, 5, 6]

      a.shift(2).should == [2, 3]
      a.should == [4, 5, 6]

      a.shift(3).should == [4, 5, 6]
      a.should == []
    end

    it "does not corrupt the array when shift without arguments is followed by shift with an argument" do
      a = [1, 2, 3, 4, 5]

      a.shift.should == 1
      a.shift(3).should == [2, 3, 4]
      a.should == [5]
    end

    it "returns a new empty array if there are no more elements" do
      a = []
      popped1 = a.shift(1)
      popped1.should == []
      a.should == []

      popped2 = a.shift(2)
      popped2.should == []
      a.should == []

      popped1.should_not equal(popped2)
    end

    it "returns whole elements if n exceeds size of the array" do
      a = [1, 2, 3, 4, 5]
      a.shift(6).should == [1, 2, 3, 4, 5]
      a.should == []
    end

    it "does not return self even when it returns whole elements" do
      a = [1, 2, 3, 4, 5]
      a.shift(5).should_not equal(a)

      a = [1, 2, 3, 4, 5]
      a.shift(6).should_not equal(a)
    end

    it "raises an ArgumentError if n is negative" do
      ->{ [1, 2, 3].shift(-1) }.should raise_error(ArgumentError)
    end

    it "tries to convert n to an Integer using #to_int" do
      a = [1, 2, 3, 4]
      a.shift(2.3).should == [1, 2]

      obj = mock('to_int')
      obj.should_receive(:to_int).and_return(2)
      a.should == [3, 4]
      a.shift(obj).should == [3, 4]
      a.should == []
    end

    it "raises a TypeError when the passed n cannot be coerced to Integer" do
      ->{ [1, 2].shift("cat") }.should raise_error(TypeError)
      ->{ [1, 2].shift(nil) }.should raise_error(TypeError)
    end

    it "raises an ArgumentError if more arguments are passed" do
      ->{ [1, 2].shift(1, 2) }.should raise_error(ArgumentError)
    end

    it "does not return subclass instances with Array subclass" do
      ArraySpecs::MyArray[1, 2, 3].shift(2).should be_an_instance_of(Array)
    end
  end
end
