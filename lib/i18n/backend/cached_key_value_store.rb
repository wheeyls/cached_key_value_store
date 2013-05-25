module I18n
  module Backend
    class CachedKeyValueStore < KeyValue
      include Memoize

      KEY_PREFIX = 'i18n:locale_version:'

      def store_translations(locale, data, options = {})
        update_version! locale
        super
      end

      def ensure_freshness!(locale)
        current = current_version locale

        if last_version[locale] != current
          reset_memoizations! locale
          last_version[locale] = current
        end
      end

      def last_version
        @last_version ||= {}
      end

      def update_version!(locale)
        @store["#{KEY_PREFIX}#{locale}"] = Time.now.to_i
      end

      def current_version(locale)
        @store["#{KEY_PREFIX}#{locale}"]
      end
    end
  end
end
