# AppleReporter

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

- getReport

```
reporter = AppleReporter::Sale.new(user_id: 'iscreen', password: 'your password')
report = reporter.getReport(
    {
    vendor_number: 'myVendor',
    report_type: 'Sales',
    report_sub_type: 'Summary',
    date_type: 'Daily',
    date: '20161212'
    }
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iscreen/apple_reporter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

