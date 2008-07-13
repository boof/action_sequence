# Builder for ActionSequence::Step.
class ActionSequence::Initializer
  
  alias_method :__eval__, :instance_eval
  instance_methods.each { |meth| undef_method(meth) unless meth =~ /\A__/ }
  
  def initialize(sequence)
    @sequence = sequence
  end
  def method_missing(name, *requires, &block)
    @sequence << ActionSequence::Step.new(name, block, requires)
  end
end

