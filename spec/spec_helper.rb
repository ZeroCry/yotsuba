$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bundler/setup'
Bundler.setup

require 'yotsuba'

Yotsuba::Serial || raise('You should set $DOMDOM_KEY before running the specs.')


