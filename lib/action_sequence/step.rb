# Author:: Florian Aßmann

class ActionSequence
  # Stores the routing for step among its name, index and requirements.
  class Step
    attr_reader :index, :name, :requires, :router

    def initialize(name, router, requires = [])
      @name, @router, @requires = name, router, requires
    end
    def set_index(index) #:nodoc:
      @index ||= Integer(index)
    end
  end
end