require "#{ File.dirname __FILE__ }/../test_helper"

describe "ActionSequence::Step" do
  it "should cast index to Integer" do
    s = ActionSequence::Step.new(:step, proc {})
    s.should._raise(ArgumentError) { s.set_index 'a' }
    s.should.not._raise(ArgumentError) { s.set_index '7' }
  end
  it "should have index setable once" do
    s = ActionSequence::Step.new(:step, proc {})
    1.upto(7) { |i| s.set_index i }
    s.index.should.be 1
  end
end
