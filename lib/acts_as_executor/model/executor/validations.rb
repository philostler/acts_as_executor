module ActsAsExecutor
  module Model
    module Executor
      module Validations
        def self.included base
          base.validates :name, :presence => true, :uniqueness => true
          base.validates :kind, :inclusion => { :in => ActsAsExecutor::Model::Executor::Kinds::ALL }
          base.validates :size, :numericality => { :only_integer => true }, :length => { :minimum => 1 }, :if => "ActsAsExecutor::Model::Executor::Kinds::REQUIRING_SIZE.include? kind"
        end
      end
    end
  end
end