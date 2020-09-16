# Suzanne

A striped-down fork of [Figaro](https://github.com/laserlemon/figaro),
allowing env variables to be managed through YAML files.

Currently meant to be used within a Rails project. Currently, like Figaro,
we assume that the config file is in `config/application.yml`.


## Suggested rails use

Place you configuration file in `config/application.yml`.
(Make sure it is not tracked by git.)

Add this line to your application's `Gemfile`:

```ruby
# Gemfile
gem 'suzanne', '~> 0.1', require: false
```
At the very bottom of `config/application.rb`:
```ruby
require 'suzanne'
Suzanne.env
```
Within your app:
```ruby
Suzanne.env.super_secret_key
```
(just like you would with Figaro.)

## Migrating from Figaro
- Follow instructions in the section above (except you probably have a config file already).
- Make sure you have a section named development (see section below).
- Substitute "Suzanne" for "Figaro" everywhere in your code base. Hopefully this is safe.
- Test

## Configuration file
It should have a section for each environment (except production).
There is no default section.
```yaml
development:
  my_aws_key: 'abcdef'

test:
  my_aws_key: 'fedcba'
```

## Usage

Define a YAML file:
```yaml
development:
  super_secret_key: abcdef

test:
  super_secret_key: fedcba
```

Initialize Suzanne:
```ruby
require 'suzanne'

Rails.env
=> 'development'
Suzanne.env.super_secret_key
=> 'abcdef'
Suzanne.env.no_such_key
=> nil
```
## Use a different a file path

To be explained

## Use outside Rails

To be tested

## Development

Run `bundle exec rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Naming
In case you are wondering about the gem name => [The_Marriage_of_Figaro](https://en.wikipedia.org/wiki/The_Marriage_of_Figaro_(play)).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Facilecomm/suzanne. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/suzanne/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Suzanne project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Facilecomm/suzanne/blob/master/CODE_OF_CONDUCT.md).
