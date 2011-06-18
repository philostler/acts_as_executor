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