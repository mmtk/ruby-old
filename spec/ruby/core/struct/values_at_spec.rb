require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Struct#values_at" do
  it "returns an array of values" do
    clazz = Struct.new(:name, :director, :year)
    movie = clazz.new('Sympathy for Mr. Vengeance', 'Chan-wook Park', 2002)
    movie.values_at(0, 1).should == ['Sympathy for Mr. Vengeance', 'Chan-wook Park']
    movie.values_at(0..2).should == ['Sympathy for Mr. Vengeance', 'Chan-wook Park', 2002]
  end

  it "fails when passed unsupported types" do
    car = StructClasses::Car.new('Ford', 'Ranger')
    -> { car.values_at('make') }.should raise_error(TypeError)
  end
end
