# Author:: Florian Aßmann

class ActionSequence
  # ActionSequence::Initializer helps building the multipage form routing.
  #
  # Example
  #
  #   enter_stuff do |s|
  #     if params[:back] then s.previous
  #     elsif @item.valid_stuff? then s.next
  #     end
  #   end # => Step.new :enter_stuff, [], proc { ... }
  #   select_other_stuff(:meth1, :meth2) do |s|
  #     if params[:back] then s.previous
  #     elsif @item.save then s[:finished]
  #     end
  #   end # => Step.new :select_other_stuff, [:meth1, :meth2], proc { ... }
  class Initializer
  
    alias_method :__eval__, :instance_eval
    instance_methods.each { |meth| undef_method(meth) unless meth =~ /\A__/ }
  
    def initialize(sequence)
      @sequence = sequence
    end
    def method_missing(name, *requires, &router)
      @sequence << ActionSequence::Step.new(name, router, requires)
    end

  end
end
