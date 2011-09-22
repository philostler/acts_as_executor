module ActsAsExecutor
  class ExecutableGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    def models
      template File.join("executables", "executable.rb"), File.join("app", "executables", file_name + ".rb")
    end
  end
end