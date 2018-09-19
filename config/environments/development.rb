Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
  config.webpacker.check_yarn_integrity = true
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = {
    protocol: ENV['RAILS_MAILER_URL_PROTOCOL'].presence || 'http',
    host: ENV['RAILS_MAILER_URL_DOMAIN'].presence || 'localhost',
    port: (ENV['RAILS_MAILER_URL_PORT'].presence || '3000').to_i,
  }
  config.action_mailer.delivery_method = (ENV['RAILS_MAILER_DELIVERY_METHOD'].presence || 'letter_opener_web').to_sym
  if config.action_mailer.delivery_method == :smtp
    config.action_mailer.smtp_settings = {
      address: ENV['RAILS_MAILER_SMTP_ADDRESS'].presence || 'localhost',
      port: (ENV['RAILS_MAILER_SMTP_PORT'].presence || '25').to_i,
      domain: ENV['RAILS_MAILER_SMTP_DOMAIN'].presence || 'localhost',
      user_name: ENV['RAILS_MAILER_SMTP_USER_NAME'].presence,
      password: ENV['RAILS_MAILER_SMTP_PASSWORD'].presence,
      authentication: ENV['RAILS_MAILER_SMTP_AUTHENTICATION'] == 'none' ? nil : ENV['RAILS_MAILER_SMTP_AUTHENTICATION'] || 'plain',
      enable_starttls_auto: ENV['RAILS_MAILER_SMTP_ENABLE_STARTTLS_AUTO'].presence || true,
      openssl_verify_mode: ENV['RAILS_MAILER_SMTP_OPENSSL_VERIFY_MODE'].presence,
      ssl: ENV['RAILS_MAILER_SMTP_SSL'].present?,
      tls: ENV['RAILS_MAILER_SMTP_TLS'].present?,
    }
  end

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.web_console.whitelisted_ips = '0.0.0.0/0'
  config.action_cable.allowed_request_origins = [ /http:\/\/.*/ ]

  config.after_initialize do
    Bullet.enable = true
    Bullet.console = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
  end

  if ENV['AUTO_LOGIN'].present?
    module AutoLogin
      def authenticate_user!
        true
      end
      def current_user
        User.find_by_email('test@example.net')
      end
    end
    ApplicationController.class_eval do
      include AutoLogin
    end
    Api::V2::ApiController.class_eval do
      include AutoLogin
    end
  end

end
