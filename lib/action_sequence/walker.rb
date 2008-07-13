class ActionSequence::Walker
  attr_reader :current

  def self.walk(sequence, controller, step)
    unless step.is_a? ActionSequence::Step
      allocate.instance_eval {
        @sequence = sequence
        @index    = controller.params[ sequence.walker ] - 1
        @current  = sequence.steps_array.at @index

        result = controller.instance_exec(self, &@current.block)
        step = (ActionSequence::Step === result) ? result : @current
      }
    end

    step.requires.each { |req| controller.send req }
    step
  end

  # Returns the previous step relative to current step.
  def previous
    @sequence.steps_array.fetch @index - 1
  end
  # Returns the next step relative to current step.
  def next
    @sequence.steps_array.fetch @index + 1
  end

  # Returns the names step.
  def [](name)
    @sequence.steps_hash.fetch name
  end

  # Calls :first on the sequence.
  def first
    @sequence.first
  end
  # Calls :last on the sequence.
  def last
    @sequence.last
  end
end
