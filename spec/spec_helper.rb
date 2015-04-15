$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bundler/setup'
Bundler.setup

require 'yotsuba'

RSpec.configure do |config|
  # This is set to ensure $DOMDOM_KEY is defined prior to running tests.
  # (Otherwise they would waste their 5 daily downloads quickly).
  # Once the teste properly implement mocks, this won't be necessary.
  config.fail_fast = true
end

