# Manatoo ruby
## Installation

You don't need this source code unless you want to modify the gem. If you just
want to use the package, just run:

    gem install manatoo

### Requirements

* Ruby 2.0+.

### Bundler

If you are installing via bundler, you should be sure to use the https rubygems
source in your Gemfile, as any gems fetched over http could potentially be
compromised in transit and alter the code of gems fetched securely over https:

``` ruby
source 'https://rubygems.org'

gem 'rails'
gem 'manatoo'
```

### For usage, please take a look at the [documentation](https://docs.manatoo.io?ruby).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
