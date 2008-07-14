# Author:: Florian Aßmann

class ActionSequence
  # Invokes the routing block.
  class Walker
    attr_reader :current

    # Returns the next step.
    #
    # A walk identifies the next step as follows:
    # * Identify the current step through walker parameter
    #   (default: :step => 1)
    # * Invoke routing block in controller scope with self
    # * Invoke required controller methods for returned ActionSequence::Step
    #   (default: current)
    # * Return step
    def self.walk(sequence, controller, step)
      unless step.is_a? ActionSequence::Step
        allocate.instance_eval {
          @sequence = sequence
          @index    = (controller.params[ sequence.walker ] || 1).to_i - 1
          @current  = sequence.steps_array.at @index

          result = controller.instance_exec(self, &@current.router)
          step = (ActionSequence::Step === result) ? result : @current
        }
      end

      step.requires.each { |req| controller.send req }
      step
    end

    # Returns the previous step relative to current ActionSequence::Step.
    def previous
      @sequence.steps_array.fetch @index - 1
    end
    # Returns the next step relative to current ActionSequence::Step.
    def next
      @sequence.steps_array.fetch @index + 1
    end

    # Returns the named ActionSequence::Step.
    def [](name)
      @sequence.steps_hash.fetch name
    end

    # Returns the first ActionSequence::Step.
    def first
      @sequence.steps_array.first
    end
    # Returns the last ActionSequence::Step.
    def last
      @sequence.steps_array.last
    end
  end
end