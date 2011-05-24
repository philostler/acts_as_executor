module ActsAsExecutor
  module Executor
    module Model
      module Validations
        def self.included base
          base.validates :name, :presence => true, :uniqueness => true
          base.validates :kind, :inclusion => { :in => ActsAsExecutor::Executor::Kinds::ALL }
          base.validates :size, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }, :if => "ActsAsExecutor::Executor::Kinds::REQUIRING_SIZE.include? kind"
        end
      end
    end
  end
end