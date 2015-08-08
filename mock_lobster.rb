require 'minitest'

class Minitest::Test
  attr_accessor :modified_objects
  def setup
    @@count = 0
    @@count == 0 ? @modified_objects = [] : @modified_objects
    @@count += 1
    $mini = self
  end

  def teardown
    @modified_objects.each { |modified_object| modified_object.reset }
  end

  def mock(method)
    Mock.new(method)
  end
end

class Object
  def stubbify(hash)
    $mini.modified_objects << self
    hash.each do |name, value|
      if methods.include?(name)
        instance_variable_set("@lobster_#{name}", method(name).to_proc)
      end
      self.send(:define_singleton_method, name) { value }
    end
  end

  def reset
    singleton_methods.each do |method|
      unless instance_variable_get("@lobster_#{method}") == nil
        instance_method = instance_variable_get("@lobster_#{method}")
        send(:define_singleton_method, method) { |*arg, &block| instance_method.call(*arg, &block) }
      else
        self.instance_eval { undef method }
      end
    end
  end
end

class Mock
  def initialize(method)
    method.each do |method_name, return_value|
      self.send(:define_singleton_method, method_name) do
        return_value
      end
    end
  end
end
