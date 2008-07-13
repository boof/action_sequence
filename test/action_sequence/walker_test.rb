require "#{ File.dirname __FILE__ }/../test_helper"
require 'ostruct'

describe "ActionSequence::Walker" do
  before(:each) do
    @sequence = ActionSequence.new :step do
      first_step { |s| s[:third_step] unless params[:blocked?] }
      second_step(:blocks) { |s| }
      third_step { |s| s.last unless params[:blocked?] }
    end
    @controller = OpenStruct.new(:params => {})
    def @controller.blocks
      params[:blocked?] = true
    end
  end
  
  it "should invoke current steps block on walk" do
    @sequence.walk(@controller).should.be @sequence.steps_hash[:third_step]
    @controller.params[:step] = '3'
    @sequence.should.be.finished_with? @sequence.walk(@controller)
  end
  it "should always return a step on walk" do
    @controller.params.update :blocked? => true
    @sequence.walk(@controller).should.be @sequence.steps_hash[:first_step]
  end
  it "should run required method for step on walk" do
    @controller.params[:step] = '2'
    @sequence.walk @controller
    @controller.params[:blocked?].should.be true
  end
end
