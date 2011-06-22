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

def double_rails_logger
  double_logger = double "Logger"
  double_logger.stub :debug
  double_logger.stub :info
  double_logger.stub :warn
  double_logger.stub :error
  double_logger.stub :fatal

  Rails.logger = double_logger
  double_logger
end

def should_receive_rails_booted? booted
  ActsAsExecutor.should_receive(:rails_booted?).and_return(booted)
end