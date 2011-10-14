module ActsAsExecutor
  class TaskGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    def models
      template File.join("tasks", "task.rb"), File.join("app", "tasks", file_name + ".rb")
    end
  end
end