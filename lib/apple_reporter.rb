require 'active_support/all'
require 'rest-client'

require 'apple_reporter/version'
require 'apple_reporter/reporter'
require 'apple_reporter/sale'
require 'apple_reporter/finance'
require 'apple_reporter/token'

module AppleReporter
  #raise "Cannot require AppleReporter, unsupported engine '#{RUBY_ENGINE}'" unless RUBY_ENGINE == "ruby"
end
