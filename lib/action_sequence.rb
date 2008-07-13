# Author::      Florian Aßmann (flazy@fork.de)
# Last Update:: 2008-07-12
#
# This class helps building multipage form.
class ActionSequence
  VERSION = [1, 0, 0]

  attr_reader :steps_array, :steps_hash, :walker

  def initialize(walker, &init)
    @steps_array, @steps_hash = [], {}
    @walker = walker

    initializer = ActionSequence::Initializer.new self
    initializer.__eval__(&init)

    finalize!
  end

  # Finalizes the sequence.
  #
  # Enqueues the :finished step unless it's already defined and freezes steps
  # containers.
  def finalize!
    @steps_hash.has_key? :finished or self << Step.new(:finished, proc {|w|})
    [@steps_array, @steps_hash].each { |c| c.freeze }
  end
  protected :finalize!

  def <<(step)
    @steps_array << step
    @steps_hash[step.name] = step

    step.set_index @steps_array.length
  end

  def first
    @steps_array.first
  end
  def last
    @steps_array.last
  end

  # Returns true if the steps index equals the length of steps container.
  def finished_with?(step)
    @steps_array.length == step.index
  end

  # Walks the controller step.
  def walk(controller, step = nil)
    Walker.walk self, controller, @steps_hash[step]
  end

  module ClassMethods
    # Creates a new sequence. This sequence is accessable through
    # :#{ name }_sequence and can be walked with :walk_#{ name }_sequence.
    #
    # After walking a sequence the step returned by walked step or the walked
    # step itself is returned.
    #
    # If the returned steps has requirements these are invoked before the step
    # is returned.
    #
    # Requirements and steps are invoked in controller instance scope.
    #
    # Example:
    #   class PeopleController < ApplicationController
    #
    #   sequence :person do
    #     enter_name do |s|
    #       if params[:back] then s.previous
    #       else
    #         s.next if @person.valid_name?
    #       end
    #     end
    #     enter_address(:selects_countries) do |s|
    #       if params[:back] then s.previous
    #       else
    #         s[:finished] if @person.valid_address?
    #       end
    #     end
    #   end
    #   before_filter :walk_person_sequence, :only => [:create, :update]
    #   def create
    #     unless person_sequence.finished_with? @step
    #       render :action => :new
    #     else
    #       if @person.save then redirect_to :action => :list
    #       else
    #         render :action => :new
    #       end
    #     end
    #   end
    def sequence(name, walker = :step, &initialization)
      sequence = ActionSequence.new(walker, &initialization)

      define_method "#{ name }_sequence" do
        sequence
      end
      define_method "walk_#{ name }_sequence" do |*step|
        instance_variable_set :"@#{ walker }", if step = step.first
          sequence.walk(self, step)
        else
          sequence.walk(self)
        end
      end
      protected "#{ name }_sequence", "walk_#{ name }_sequence"
    end
  end

end

require __FILE__.insert(-4, '/initializer')
require __FILE__.insert(-4, '/step')
require __FILE__.insert(-4, '/walker')
