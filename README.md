![maskerade.png](maskerade.png)

# Maskerade

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'maskerade'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install maskerade

## Usage

```ruby
masker = ::Maskerade::CreditCardMasker.new(:replacement_token => "X", :expose_last => 4)
masker.mask("4111-1111-1111-1111")  # "XXXX-XXXX-XXXX-1111"
```

```ruby
masker = ::Maskerade::CreditCardMasker.new(:replacement_text => "[MASKED]")
masker.mask("4111-1111-1111-1111")  # "[MASKED]"
```

## Notes

This gem works similar to the zendesk credit_card_sanitizer gem, but has the advantage of being able to work
even when the card number is preceded or followed by extra numbers:
* E.g., it works on "Starbucks Store #555 6011 0726 6818 0642"
* See https://github.com/zendesk/credit_card_sanitizer/issues/47

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
