ActiveRecord::Base.establish_connection(
  :adapter => "jdbcsqlite3",
  :database => ":memory:"
)