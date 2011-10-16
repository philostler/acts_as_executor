class Create<%= class_name.pluralize %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.string   :name
      t.integer  :limit
      t.timestamps
    end

    create_table :<%= singular_table_name %>_tasks do |t|
      t.integer  :executor_id
      t.string   :task
      t.string   :arguments
      t.integer  :start
      t.integer  :every
      t.boolean  :every_strict
      t.datetime :started_at
      t.datetime :completed_at
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
    drop_table :<%= singular_table_name %>_tasks
  end
end