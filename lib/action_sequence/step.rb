class ActionSequence::Step
  attr_reader :block, :index, :name, :requires

  def initialize(name, block, requires = [])
    @name, @block, @requires = name, block, requires
  end
  # Invokes the block for self with given walker.
  def [](walker)
    @block[walker]
  end
  # Initializes index casted to Integer once.
  def set_index(index)
    @index ||= Integer(index)
  end
end
