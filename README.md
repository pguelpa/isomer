# Isomer

[![Build Status](https://travis-ci.org/pguelpa/isomer.png?branch=master)](https://travis-ci.org/pguelpa/isomer)

Isomer is a gem to help manage your application's configuration with the idea that configuration objects should be separate from the source they are loaded from. This allows you change where you store your configuration without breaking any internal code which uses that configuration object.

## Installation

Add this line to your application's Gemfile:

    gem 'isomer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install isomer

## Usage

Jumping right into a usage example:

```ruby
nucleus = Isomer::Nucleus.new do |n|
  n.parameter :url, name: 'host'
  n.parameter :api_key, required: true
  n.parameter :timeout
  n.parameter :logger, default: Rails.logger
end

yaml = Isomer::Sources::YAML.new(File.join('config', 'fancy.yml'))
environment = Isomer::Sources::Enviroment.new(prefix: 'FANCY_')

CONFIG = Isomer::Configuration.hydrate(nucleus, yaml, environment)

...

Client.new(CONFIG.url, timeout: CONFIG.timeout)
```

## Nucleus

The `Nucleus` is what defines the structure of your configuration. A nucleus is made up of one or more parameters. Each parameter requires a name which is how you access the value from the configuration object. It is also the default value used to lookup a parameter from a given source.

Additionally, you can specify options for an alternative lookup name, for a default value, and to flag a parameter as required.

* `required`: Means this parameter is required.  If any are missing, `validate!` will raise a Isomer::RequiredParameterError.  Defaults to `false`
* `name`: If the configuration source uses a different name than that of the parameter
* `default`: If you want to specify a default value

### Example

```ruby
nucleus = Isomer::Nucleus.new do |n|
  n.parameter :url, name: 'host'
  n.parameter :api_key, required: true
  n.parameter :timeout
  n.parameter :logger, default: Rails.logger
end
```

## Sources

Sources handle how to lookup a configuration value. You need to define the source that you want to load the configuration from. Isomer comes with sources for:

- YAML files `Isomer::Sources::YAML`
- Environment variables `Isomer::Sources::Environment`
- Hashes `Isomer::Sources::Dictionary`

You can also define and use your own source by inheriting from and adhering to the interface defined in `Isomer::Sources::Base`.

### YAML

#### Options

* `base`: If there are multiple configurations (eg. for different environments), you can specify which one to use
* `required`: If the configuration file is required

#### Example

```ruby
Isomer::Sources::YAML.new(File.join('config', 'fancy.yml'), base: Rails.env, required: true)
```

### Environment

#### Options

* `convert_case`: Should we automatically uppercase any parameter names when looking for the environment variable (defaults to `true`)
* `prefix`: Add a prefix when looking up all parameters in the environment

#### Example

```ruby
Isomer::Sources::Enviroment.new(prefix: 'FANCY_')
```

### Hash

#### Example

```ruby
Isomer::Sources::Dictionary.new('foo' => 'bar')
```

## Configuration


Configuration objects are hydrated from a nucleus and one or more sources. A new object will be returned to you which is the instance of your configuration populated with values from the source objects.

When multiple sources are given, the latter will take precedence over the former.

You can check the validity of a configuration object by calling `valid?` on it. You can get an array of errors back by calling `errors`.

#### Example

```ruby
CONFIG = Isomer::Configuration.hydrate(nucleus, yaml, environment)

...

Client.new(CONFIG.url, timeout: CONFIG.timeout)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
