$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'apple_reporter'
require 'rspec'
require 'active_support/all'
require 'webmock/rspec'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

RSpec.configure do |config|
end