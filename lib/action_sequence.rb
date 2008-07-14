# Author:: Florian Aßmann

# Storage for routing.
class ActionSequence
  
  VERSION = [1, 0, 2]

  attr_reader :steps_array, :steps_hash, :walker

  # Stores walker parameter name and runs Initializer.
  def initialize(walker, &init)
    @steps_array, @steps_hash = [], {}
    @walker = walker

    initializer = ActionSequence::Initializer.new self
    initializer.__eval__(&init)

    finalize!
  end

  # Adds a ActionSequence::Step to instance and sets the index.
  def <<(step)
    @steps_array << step
    @steps_hash[step.name] = step

    step.set_index @steps_array.length
  end

  # Returns the first ActionSequence::Step.
  def first
    @steps_array.first
  end
  # Returns the last ActionSequence::Step.
  def last
    @steps_array.last
  end

  # Returns true if the ActionSequence::Step is the last.
  def finished_with?(step)
    @steps_array.length == step.index
  end

  # Invokes ActionSequence::Walker with self, controller and the named step.
  def walk(controller, step = nil)
    Walker.walk self, controller, @steps_hash[step]
  end

  # Extends ActionController::Base.
  module ClassMethods
    # Creates a new sequence. This sequence is accessable through
    # :#{ name }_sequence and can be walked with :walk_#{ name }_sequence.
    #
    # See: Initializer, Walker
    def sequence(name, walker = :step, &initialization)
      sequence = ActionSequence.new(walker, &initialization)

      define_method "#{ name }_sequence" do
        sequence
      end
      define_method "walk_#{ name }_sequence" do |*step|
        instance_variable_set "@#{ walker }".to_sym, if step = step.first
          sequence.walk(self, step)
        else
          sequence.walk(self)
        end
      end
      protected "#{ name }_sequence", "walk_#{ name }_sequence"
    end
  end

  private
  # Finalizes the sequence.
  #
  # Enqueues the :finished step unless it's already defined and freezes steps
  # containers.
  def finalize!
    @steps_hash.has_key? :finished or self << Step.new(:finished, proc {|w|})
    [@steps_array, @steps_hash].each { |c| c.freeze }
  end

end

require __FILE__.insert(-4, '/initializer')
require __FILE__.insert(-4, '/step')
require __FILE__.insert(-4, '/walker')
