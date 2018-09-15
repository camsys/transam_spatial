RSpec.configure do |config|
  # additional factory_bot configuration
  config.before(:suite) do
    begin
      #FactoryBot.lint
    ensure
    end
  end
end
