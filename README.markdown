# acts_as_executor

acts_as_executor seamlessly integrates Java’s Executor framework with JRuby on Rails, enabling an application to use executors in a familiar Rails’eque way.

[RubyGems][ruby_gems] | [GitHub][github] | [Travis CI][travis_ci] | [RubyDoc][ruby_doc] | [Wiki][wiki]

## Features
* **Abstraction** from low-level executor type configuration
* **ActiveRecord** interface so creating an executor or task is as simple is creating a record
* **Automatic Task Setup** so you can concentrate on business logic and not task management
* **Database Persisted Configuration** so executors can be managed through migrations and seeds
* **Logging** of executor and task states to Rails or custom logger

## 1. Install
```ruby
gem "acts_as_executor"
```
...or for life on the edge, use the [master branch][github_master] [![Build Status][travis_ci_build_status]][travis_ci]

```ruby
gem "acts_as_executor", :git => "git@github.com:philostler/acts_as_executor.git"
```

## 2. Generate
Generate models and migration using

```
rails g acts_as_executor <model_name>
```

Example

```
rails g acts_as_executor Executor
      create  app/models/executor.rb
      create  app/models/executor_task.rb
      create  db/migrate/20110821155835_create_executors.rb
```

## 3. Execute!
You'll first need an executor available to schedule tasks upon.

```ruby
Executor.create :name => "background"
```

These can be created on the fly at runtime (be sure to save the record before you schedule any tasks) or be preconfigured via records already present in the database. The recommended method is to add the applications required executors to the database seed file and running ```rake db:seed```.

Attributes ```max_tasks``` and ```schedulable``` exist on the executors model for task limiting and schedulable ability enabling. Check out the wiki documentation for details of how these work.

[Using Executors][wiki_using_executors]

Once you have an executor available, it's time to add some tasks. Do this like you would any associated record.

```ruby
Executor.find_by_name("background").tasks.create(:clazz => "BackgroundTask",
                                                 :arguments => { :data => "This is my data")
```

The ```clazz``` attribute references a class that must...

* Be available in the load path
* Include ```ActsAsExecutor::Task::Clazz```
* Define an ```execute``` method

A simple task implementation would look like this.

```ruby
class BackgroundTask
  includes ActsAsExecutor::Task::Clazz

  def execute
    p data
  end
end
```

Anything passed into the ```attributes``` hash will be available to the instance when it is executed.

Attributes ```schedule```, ```start```, ```every``` and ```units``` exist on the tasks model for defining the type and periods for scheduling and their units. Check out the wiki documentation for details of how these work.

[Using Tasks][wiki_using_tasks]

## Compatibility
* JRuby 1.6.x
* Rails 3.x

[github]: https://github.com/philostler/acts_as_executor
[github_master]: https://github.com/philostler/acts_as_executor/tree/master
[ruby_doc]: http://rubydoc.info/github/philostler/acts_as_executor/master/frames
[ruby_gems]: http://rubygems.org/gems/acts_as_executor
[travis_ci]: http://travis-ci.org/philostler/acts_as_executor
[travis_ci_build_status]: https://secure.travis-ci.org/philostler/acts_as_executor.png
[wiki]: https://github.com/philostler/acts_as_executor/wiki
[wiki_using_executors]: https://github.com/philostler/acts_as_executor/wiki/Using-Executors
[wiki_using_tasks]: https://github.com/philostler/acts_as_executor/wiki/Using-Tasks