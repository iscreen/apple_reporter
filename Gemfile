source 'https://rubygems.org'

# Specify your gem's dependencies in apple_reporter.gemspec
gemspec

group :development do
  gem 'rake'
  gem 'webmock'

  platforms :mri do
    # to avoid problems, bring Byebug in on just versions of Ruby under which
    # it's known to work well
    if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.0.0')
      gem 'byebug'
      gem 'pry'
      gem 'pry-byebug'
    end
  end
end