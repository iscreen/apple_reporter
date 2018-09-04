# AppleReporter

[![Gem Downloads](http://ruby-gem-downloads-badge.herokuapp.com/apple_reporter?type=total)](https://rubygems.org/gems/apple_reporter)
[![Build Status](https://travis-ci.org/iscreen/apple_reporter.svg?branch=master)](https://travis-ci.org/iscreen/apple_reporter)
[![Code Climate](https://codeclimate.com/github/iscreen/apple_reporter.svg)](https://codeclimate.com/github/iscreen/apple_reporter)
[![Inline docs](https://inch-ci.org/github/iscreen/apple_reporter.svg?branch=master)](http://www.rubydoc.info/gems/apple_reporter)


This is Ruby Version <b>iTunes Connect Reporter</b>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apple_reporter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apple_reporter

## Usage

### Sales

- get_report

```ruby
reporter = AppleReporter::Sale.new(user_id: 'your user id', access_token: 'your access token')
report = reporter.get_report(
  vendor_number: 'your vender id',
  report_type: 'Sales',
  report_sub_type: 'Summary',
  date_type: 'Daily',
  date: '20161212'
)
```
### Finance

- get_report

```ruby
reporter = AppleReporter::Finance.new(user_id: 'your user id', access_token: 'your access token')
report = reporter.get_report(
  vendor_number: 'your vender id',
  region_code: 'US',
  report_type: 'Financial',
  fiscal_year: '2016',
  fiscal_period: '02'
)
```

- get_report with version

```ruby
reporter = AppleReporter::Finance.new(
  user_id: 'your user id', 
  access_token: 'your access token'
  version: '1_1'
)
report = reporter.get_report(
  vendor_number: 'your vender id',
  region_code: 'US',
  report_type: 'Financial',
  fiscal_year: '2016',
  fiscal_period: '02'
)
```

### AccessToken

- view

```ruby
reporter = AppleReporter::Token.new(user_id: 'your user id', password: 'your password')
token_info = reporter.view
```

- generate

```ruby
reporter = AppleReporter::Token.new(user_id: 'your user id', password: 'your password')
token_info = reporter.generate
```
- delete

```ruby
reporter = AppleReporter::Token.new(user_id: 'your user id', password: 'your password')
reporter.delete
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iscreen/apple_reporter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

