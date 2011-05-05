class Create<%= class_name.pluralize %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.string   :name
      t.string   :kind
      t.integer  :size
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end