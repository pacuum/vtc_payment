# VtcPayment

This is a library to handle payment using VTC Intercom gateway. VTC is a Vietnamese company.

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
VtcPayment::Bank::Request.production_url = "...." # set if you want to run in production
req = VtcPayment::Bank::Request::Bank::Vietcombank.new("ACCOUNT", 9999, "SECRET_KEY", "https://your.web.site/")
req.sandbox = true
params = {
  amount: 100_000, # VND
  order_id: Time.now.strftime("%Y%m%e%H%M%S"),
}
puts req.url(params)
```
See official document for available list of Bank names. Note that in the sandbox environment bank transfer will not work.

#### VISA/Master Credit card
```ruby
req = VtcPayment::Bank::Request::CreditCard::Visa.new(account, website_id, secret_key, callback_url)
puts req.url(params)
```
```ruby
req = VtcPayment::Bank::Request::CreditCard::Master.new(account, website_id, secret_key, callback_url)
puts req.url(params)
```
The only difference among all cases is the class to instantiate.

#### Handling users response
When bank/credit card payment is successful, user is redirected to callback_url with parameter.
```ruby
parser = VtpPayment::NotificationParser.new(SECRET_KEY)
result = parser.parse_users_request(params)
p [ result.successful?, result.order_id, result.amount, result.code, result.message ]
```

#### Notification API
```ruby
parser = VtpPayment::NotificationParser.new(SECRET_KEY)
result = parser.parse_notification(data, signature)
p [ result.successful?, result.order_id, result.amount, result.code, result.message ]

```

### Mobile card
```ruby
VtcPayment::MobileCard::Client.production_url = "..." # set if you use in production
client = VtcPayment::MobileCard::Client.new("ACCOUNT", "SECRET_KEY")
client.sandbox = true
client =  result.execute("CARDID", "SERIAL", "any information of your customer")
p [ result.successful?, result.amount, result.code, result.message ] # it does not have order_id
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/vtc_payment. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

