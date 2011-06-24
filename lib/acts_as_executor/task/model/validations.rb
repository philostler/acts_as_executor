module ActsAsExecutor
  module Task
    module Model
      module Validations
        def self.included base
          base.validates :executor_id, :presence => true
          base.validates :clazz, :presence => true, :class_exists_with_required_module => true
          base.validates :schedule, :inclusion => { :in => ActsAsExecutor::Task::Schedules::ALL }, :if => "executor and executor.schedulable?"
          base.validates :start, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }, :if => "executor and executor.schedulable?"
          base.validates :every, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }, :if => "executor and executor.schedulable? and schedule != ActsAsExecutor::Task::Schedules::ONE_SHOT"
          base.validates :units, :inclusion => { :in => ActsAsExecutor::Common::Units::ALL }, :if => "executor and executor.schedulable?"
        end
      end
    end
  end
end