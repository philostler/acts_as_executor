InstanceSupportMethods.blueprint do
end

Executor.blueprint do
  id        { "#{sn}" }
  name      { "name#{sn}" }
  max_tasks { 1 }
end

ExecutorTask.blueprint do
  id         { "#{sn}" }
  executor
  executable { "Executable" }
  arguments  { {:attribute_one => "attribute_one_value", :attribute_two => "attribute_two_value"} }
end

Executable.blueprint do
  arguments { {:attribute_one => "attribute_one_value", :attribute_two => "attribute_two_value"} }
  object.stub :execute
end