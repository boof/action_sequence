require "#{ File.dirname __FILE__ }/../test_helper"

describe "ActionSequence::Initializer" do
  it "should << missing methods as named steps" do
    ActionSequence::Initializer.new(sequence = []).__eval__ { set }
    step = sequence.first

    step.should.be.an.instance_of ActionSequence::Step
    step.name.should.be :set
  end
end
