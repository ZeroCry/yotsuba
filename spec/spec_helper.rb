$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bundler/setup'
Bundler.setup

require 'yotsuba'

RSpec.configure do |config|
  config.fail_fast = true
end

