SpreeBraintreeVzero22::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.domain = 'spree-braintree-vzero-3-0.herokuapp.com'
  config.cdn = 's3.amazonaws.com/spree-braintree-vzero-3-0'

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like
  # NGINX, varnish or squid.
  config.action_dispatch.rack_cache = true

  # Action mailer con host production
  config.action_mailer.default_url_options = { :host => 'https://' + config.domain }

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.static_cache_control = 'public, max-age=31536000'

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :warn

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  if ENV["MEMCACHEDCLOUD_SERVERS"]
    config.cache_store = :mem_cache_store, ENV["MEMCACHEDCLOUD_SERVERS"].split(','), {
      :username => ENV["MEMCACHEDCLOUD_USERNAME"],
      :password => ENV["MEMCACHEDCLOUD_PASSWORD"]
    }

    client = Dalli::Client.new(ENV["MEMCACHEDCLOUD_SERVERS"].split(','), {
      :username => ENV["MEMCACHEDCLOUD_USERNAME"],
      :password => ENV["MEMCACHEDCLOUD_PASSWORD"]
    })

    config.action_dispatch.rack_cache = {
      :metastore    => client,
      :entitystore  => client
    }
  end

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  config.action_controller.asset_host = config.action_mailer.asset_host = 'https://' + config.cdn

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Amazon S3 for paperclip
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET_NAME'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    },
    s3_headers:     { 'Cache-Control' => 'max-age=31557600' },
    :s3_protocol => :https,
    :url => ':s3_alias_url',
    :s3_host_alias => config.cdn,
    :path => ':class/:attachment/:id_partition/:style/:filename'
  }

  # sendgrid mail
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :domain => config.domain,
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end
