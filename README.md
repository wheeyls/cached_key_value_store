# CachedKeyValueStore

Sending redis a request for each of those thousands of translations scattered
throughout your app is slow. This gem memoizes those requests, and sets up a
simple mechanism to bust the cache.

If you want to use Redis for I18n, I recommend you watch
[this railscast](http://railscasts.com/episodes/256-i18n-backends),
and use this backend instead of the KeyValue one that he uses.

## Installation

Add this line to your application's Gemfile:

    gem 'cached_key_value_store'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cached_key_value_store

## Usage

In your initializer:

    I18n.backend = I18n::Backend::CachedKeyValueStore.new($redis)

### Busting the Cache

The ```#ensure_freshness!``` method can be called periodically to make sure
that new changes show up. I put mine in a before filter:

    class ApplicationController < ActionController::Base
      before_filter :ensure_fresh_i18n

      private
      def ensure_fresh_i18n
        I18n.backend.ensure_freshness! I18n.locale
      end
    end

This method will only work if you use the ```#store_translations``` method
to update your locales.

You can also call ```#update_version!(locale)``` directly to signal that the
translations have been modified.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
