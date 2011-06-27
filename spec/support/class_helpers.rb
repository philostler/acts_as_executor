def define_clazz_class class_name
  unless Object.const_defined? class_name
    constant = Object.const_set class_name, Class.new
    constant.send :include, ActsAsExecutor::Task::Clazz
  end
  Object.const_get class_name
end

def define_executor_model_class class_name
  unless Object.const_defined? class_name
    ActiveRecord::Schema.define do
      self.verbose = false

      create_table class_name.tableize, :force => true do |t|
        t.string  :name
        t.string  :kind
        t.integer :size
      end
    end

    Object.const_set class_name, Class.new(ActiveRecord::Base)
  end
  Object.const_get class_name
end

def define_executor_task_model_class class_name
  unless Object.const_defined? class_name
    ActiveRecord::Schema.define do
      self.verbose = false

      create_table class_name.tableize, :force => true do |t|
        t.integer  :executor_id
        t.string   :clazz
        t.string   :arguments
        t.string   :schedule
        t.integer  :start
        t.integer  :every
        t.string   :units
      end
    end

    Object.const_set class_name, Class.new(ActiveRecord::Base)
  end
  Object.const_get class_name
end