# Taken from: http://www.ruby-forum.com/topic/54096

class Object #:nodoc:
  def instance_exec(*args, &block)
    mname = "__instance_exec_#{ Thread.current.object_id.abs }"
    class << self; self end.class_eval { define_method(mname, &block) }
    begin
      ret = send(mname, *args)
    ensure
      class << self; self end.class_eval { undef_method(mname) } rescue nil
    end
    ret
  end unless RUBY_VERSION >= '1.9'
end

