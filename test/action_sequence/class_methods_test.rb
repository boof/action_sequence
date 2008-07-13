require "#{ File.dirname __FILE__ }/../test_helper"

describe "ActionController::Base" do
  before(:each) do
    @test = Class.new(ActionController::Base) do
      def params
        @params ||= {:step => 1}
      end
    end
  end
  
  it "should define protected sequence reader" do
    @test.sequence(:test) {}
    @test.protected_instance_methods.should.include? 'test_sequence'
    instance = @test.new
    instance.send(:test_sequence).should.be.an.instance_of ActionSequence
  end
  it "should define protected sequence walker" do
    @test.sequence(:test) {}
    @test.protected_instance_methods.should.include? 'walk_test_sequence'
    instance = @test.new
    last_step = instance.send(:walk_test_sequence)
    instance.send(:test_sequence).should.be.finished_with? last_step
  end
  it "should walk a specific step" do
    @test.sequence(:test) { finished { |s| raise } }
    @test.protected_instance_methods.should.include? 'walk_test_sequence'
    instance = @test.new
    instance.should.not._raise RuntimeError do
      last_step = instance.send(:walk_test_sequence, :finished)
      last_step.name.should.be :finished
    end
  end
end
