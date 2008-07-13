require "#{ File.dirname(__FILE__) }/lib/action_sequence.rb"
require "#{ File.dirname(__FILE__) }/lib/object.rb"

ActionController::Base.extend ActionSequence::ClassMethods
