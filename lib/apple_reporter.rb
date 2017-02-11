require 'apple_reporter/version'
require 'apple_reporter/sale'

require 'active_support/all'

module AppleReporter
  raise "Cannot require AppleReporter, unsupported engine '#{RUBY_ENGINE}'" unless RUBY_ENGINE == "ruby"
end
