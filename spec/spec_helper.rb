require "acts_as_executor"
require "acts_as_executor/version"

ActiveRecord::Base.establish_connection(
  :adapter => "jdbcsqlite3",
  :database => ":memory:"
)

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :executors, :force => true do |t|
    t.string  :name
    t.string  :kind
    t.integer :size
  end
end

class Executor < ActiveRecord::Base
  acts_as_executor
end