module ActsAsExecutor
  module Model
    module Task
      module Validations
        def self.included base
          base.validates :executor_id, :presence => true
          base.validates :clazz, :presence => true, :class_exists => true
          base.validates :schedule, :inclusion => { :in => ActsAsExecutor::Model::Task::Schedules::ALL }, :if => "executor and executor.schedulable?"
          base.validates :start, :numericality => { :only_integer => true }, :length => { :minimum => 0 }, :if => "executor and executor.schedulable?"
          base.validates :every, :numericality => { :only_integer => true }, :length => { :minimum => 1 }, :if => "executor and executor.schedulable? and schedule != ActsAsExecutor::Model::Task::Schedules::ONE_SHOT"
          base.validates :unit, :inclusion => { :in => ActsAsExecutor::Model::Task::Units::ALL }, :if => "executor and executor.schedulable?"
        end
      end
    end
  end
end