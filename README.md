# OwncloudUserProvisioning

Simple interface to Ownlcloud's User Provisionin API.

https://doc.owncloud.org/server/8.0/admin_manual/configuration_user/user_provisioning_api.html

Tested with 8.0.4 version.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'owncloud_user_provisioning'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install owncloud_user_provisioning

## Usage

The gem uses dotenv to load the owncloud username and password to access the api.

Example
#.env file
OWNCLOUD_USER=user_that_can_create_users

OWNCLOUD_PASSWORD=password

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alextakitani/owncloud_user_provisioning.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

