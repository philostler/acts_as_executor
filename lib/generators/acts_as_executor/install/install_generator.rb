module ActsAsExecutor
  class InstallGenerator < Rails::Generators::NamedBase
    include Rails::Generators::Migration

    source_root File.expand_path("../templates", __FILE__)

    def models
      template File.join("models", "executor.rb"), File.join("app", "models", file_name + ".rb")
      template File.join("models", "executor_task.rb"), File.join("app", "models", file_name + "_task.rb")
    end

    def migration
      if Rails::VERSION::STRING.to_f >= 3.1
        migration_template File.join("migration", "create_executors.rb"), File.join("db", "migrate", "create_" + table_name + ".rb")
      else
        migration_template File.join("migration", "create_executors_prior_syntax.rb"), File.join("db", "migrate", "create_" + table_name + ".rb")
      end
    end

    def self.next_migration_number dirname
      Time.now.utc.strftime "%Y%m%d%H%M%S"
    end
  end
end