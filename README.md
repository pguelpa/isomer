# Isomer

[![Build Status](https://travis-ci.org/pguelpa/isomer.png?branch=master)](https://travis-ci.org/pguelpa/isomer)

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
MY_FANCY_CONFIGURATION = Isomer.configure(:yaml, file: File.join('config', 'fancy.yml')) do |config|
  config.parameter :url, name: 'host'
  config.parameter :api_key, required: true
  config.parameter :timeout

  config.parameter :logger, default: Rails.logger
end
```

If you have a more complex setup, or want add extra methods to your configuration class, you can create your own.

```ruby
class MyFancyConfiguration < Isomer::Base
  parameter :url, name: 'host'
  parameter :api_key, required: true
  parameter :timeout

  parameter :logger, default: Rails.logger
end

...

# In some initializer
MY_FANCY_CONFIG = MyFancyConfiguration.from(:yaml, file: File.join('config', 'fancy.yml'))
```

## Parameters

The core of Isomer is allowing you to define the parameters to pull out of your configuration source.  It takes a parameter name along with a number of options.

The name will be how you access the value from the configuration object.  It also is the default value used when trying to find the value of the parameter in the source.

You can also specify a number of parameters:

* `required`: Means this parameter is required.  If any are missing, `from` will raise a Isomer::RequiredParameterError.  Defaults to `false`
* `name`: If the configuration source uses a different name than that of the parameter
* `default`: If you want to specify a default value

## Sources

### Initialize with a YAML file

#### Options

* `file`: Path to the YAML file (required)
* `base`: If there are multiple configurations (eg. for different environments), you can specify which one to use
* `required`: If the configuration file is required


#### Example

```ruby
MY_FANCY_CONFIGURATION = MyFancyConfiguration.from(:yaml, file: Rails.root.join('config', 'fancy.yml'), base: Rails.env) do |config|
  ...
end
```

### Initialize with environment variables

#### Options

* `convert_case`: Should we automatically uppercase any parameter names when looking for the environment variable (defaults to `true`)
* `prefix`: Add a prefix when looking up all parameters in the environment

#### Example

```ruby
MY_FANCY_CONFIGURATION = MyFancyConfiguration.from(:environment, prefix: 'FANCY_CONFIG_') do |config|
  ...
end
```

### Initialize with a hash (useful for testing)

#### Options

* `payload`: The hash of values that you want

#### Example

```ruby
MY_FANCY_CONFIGURATION = MyFancyConfiguration.from(:test, payload: {'foo' => 'bar'}) do |config|
  ...
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
