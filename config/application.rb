require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Capacity
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # config.encryption_salt = "?\x118\x11\a\xCBt\xA3\xB5\x93}w\x01C\xCDk\xC3\xECX\xC4\xB0\xB8\xD5\x8A\\\xA79\xD0\xC7i\r'"
    #User SecureRandom.random_bytes(32) to create salt
    config.encryption_salt = "\xA6\xD7Q5\v\x98>\x11Fwa\x8F(\xE5'\xDF\xE1\xCB\xE3\x92\xC2\xA1J\xA2vMO#[h\xCF\x87"
    config.encryption_key_length = 32

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
