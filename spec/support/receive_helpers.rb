def should_receive_rails_booted? booted
  ActsAsExecutor.stub(:rails_booted?) do
    booted
  end
end