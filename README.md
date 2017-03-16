# VtcPayment

This is a library to handle

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vtc_payment'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vtc_payment

## Usage

### Bank/Credit card

#### Specific bank
```ruby
  req = VtcPayment::Bank::Request::Bank::Vietcombank.new("YOURACCOUNT", 9999, "your secret key", "https://your.web.site/")
  req.sandbox = true
  params = {
    amount: 100_000, # VND
    order_id: Time.now.strftime("%Y%m%e%H%M%S"),
  }
  puts req.url(params)
```

#### VISA Credit card
```ruby
  req = VtcPayment::Bank::Request::CreditCard::Visa.new(account, website_id, secret_key, callback_url)
  puts req.url(params)
```
The only difference is the class to instantiate.


### Mobile card

```ruby
  client = VtcPayment::MobileCard::Client.new("ACCOUNT", "SECRET_KEY")
  client.sandbox = true
  res =  client.execute("CARDID", "SERIAL", "any information of your customer")
  p [ res.successful?, res.code, res.message ]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/vtc_payment. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

