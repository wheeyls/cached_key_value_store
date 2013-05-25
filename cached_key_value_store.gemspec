$:.push File.expand_path('../lib', __FILE__)
require 'cached_key_value_store/version'

Gem::Specification.new do |s|
  s.name          = 'cached-key-value-store'
  s.version       = CachedKeyValueStore::VERSION
  s.summary       = 'An I18n Backend with in-memory cacheing'
  s.description   = %q{This gem is designed for usage with a key-value store database, where latency is an issue. Locale changes are versioned to allow for an easy cache-bust. }
  s.authors       = ['Mike Wheeler']
  s.email         = 'mwheeler@g2crowd.com'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/cached-key-value-store'
end
