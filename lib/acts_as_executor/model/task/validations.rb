module ActsAsExecutor
  module Model
    module Task
      module Validations
        def self.included base
          base.validates :executor_id, :presence => true
          base.validates :clazz, :presence => true, :class_exists => true
#          base.validates :schedule, :inclusion => { :in => ActsAsExecutor::Task::Schedules::ALL }, :if => "executor and ActsAsExecutor::Executor::Kinds::ALL_SCHEDULED.include? executor.kind and schedule"
#          base.validates :start, :numericality => { :only_integer => true }, :length => { :minimum => 0 }, :if => "executor and ActsAsExecutor::Executor::Kinds::ALL_SCHEDULED.include? executor.kind and ActsAsExecutor::Task::Schedules::REQUIRING_START.include? schedule"
#          base.validates :every, :numericality => { :only_integer => true }, :length => { :minimum => 1 }, :if => "executor and ActsAsExecutor::Executor::Kinds::ALL_SCHEDULED.include? executor.kind and ActsAsExecutor::Task::Schedules::REQUIRING_EVERY.include? schedule"
#          base.validates :unit, :inclusion => { :in => ActsAsExecutor::Task::Units::ALL }, :if => "executor and ActsAsExecutor::Executor::Kinds::ALL_SCHEDULED.include? executor.kind and ActsAsExecutor::Task::Schedules::REQUIRING_UNIT.include? schedule"
        end
      end
    end
  end
end