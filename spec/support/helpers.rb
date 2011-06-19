def double_executor_model class_name
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

def double_executor_task_model class_name
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