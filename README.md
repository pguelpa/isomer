# Isomer

Isomer is a gem to help manage your application's configuration files.
It is built with the following ideas in mind:

* Easily define, store, and save configuration parameters
* Work with YAML files and environment variables
* Allow for mapping from file / environment variables to parameter
* Allow for required parameters
* Allow for default parameters

## Installation

Add this line to your application's Gemfile:

    gem 'isomer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install isomer

## Usage

For most configurations, you can use the simple setup approach

```ruby
MY_FANCY_CONFIGURATION = Isomer.configure(:yaml, base: Rails.env) do |config|
  config.parameter :url # defaults to { required: false, from: 'url', default: nil }
  config.parameter :api_key
  config.parameter :timeout

  config.parameter :logger, default: Rails.logger
end
```

If you have a more complex setup, or want add extra methods to your configuration class, you can create your own.

```ruby
class MyFancyConfiguration < Isomer::Base
  parameter :url # defaults to { required: false, name: 'url', default: nil }
  parameter :api_key, required: true
  parameter :timeout

  parameter :logger, default: Rails.logger
end
```

### Initialize with a YAML file

```ruby
MY_FANCY_CONFIGURATION = MyFancyConfiguration.from(:yaml, file: Rails.root.join('config', 'app_card.yml'), base: Rails.env)
```

### Initialize with environment variables

```ruby
MY_FANCY_CONFIGURATION = MyFancyConfiguration.from(:environment, prefix: 'FANCY_CONFIG_')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
