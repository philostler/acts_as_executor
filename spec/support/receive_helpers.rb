def should_receive_rails_booted? booted
  ActsAsExecutor.should_receive(:rails_booted?).and_return(booted)
end