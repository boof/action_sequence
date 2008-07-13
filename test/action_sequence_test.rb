require "#{ File.dirname __FILE__ }/test_helper"

describe "ActionSequence" do
  it "should run block on initialize" do
    s = ActionSequence.new(:step) { initialization {|s|} }
    s.steps_hash[:initialization].name.should.be(:initialization)
  end
  it "should append :finished step on initialize if missing" do
    s = ActionSequence.new(:step) { finished {|s|} }
    s.last.index.should.be 1

    s = ActionSequence.new(:step) { not_finished {|s|} }
    s.last.name.should.be :finished
    s.last.index.should.be 2
  end
  it "should freeze steps collections on initialize" do
    s = ActionSequence.new(:step) {}
    s.steps_array.should.be.frozen?
    s.steps_hash.should.be.frozen?
  end
  it "should be finished with last step" do
    s = ActionSequence.new(:step) {}
    s.should.be.finished_with? s.last
  end
end
