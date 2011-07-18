require "test/unit"
require "shoulda"
require "redgreen"

require "./folio"
 
class TestFolio < Test::Unit::TestCase
 
  context "Running folio without arguments" do
    should "raise an exception" do
      assert_raise(ArgumentError) { Folio.new }
    end
  end
  
  context "Running folio with arguments" do
    should "not raise an exception" do
      assert_nothing_raised(ArgumentError) { Folio.new 'param'}
    end 
  end
end

