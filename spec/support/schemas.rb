ActiveRecord::Schema.define do
  self.verbose = false

  create_table :executors, :force => true do |t|
    t.string  :name
    t.string  :kind
    t.integer :size
  end

  create_table :executor_without_extensions, :force => true do |t|
    t.string  :name
    t.string  :kind
    t.integer :size
  end
end