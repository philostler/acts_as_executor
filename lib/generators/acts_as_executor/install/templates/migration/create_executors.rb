class Create<%= class_name.pluralize %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.string   :name
      t.integer  :max_tasks
      t.boolean  :schedulable
      t.timestamps
    end

    create_table :<%= singular_table_name %>_tasks do |t|
      t.integer  :executor_id
      t.string   :clazz
      t.string   :arguments
      t.string   :schedule
      t.integer  :start
      t.integer  :every
      t.string   :units
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
    drop_table :<%= singular_table_name %>_tasks
  end
end