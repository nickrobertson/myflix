Myflix::Application.configure do
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :port => 25,
      :address => "smtp.mailgun.org",
      :user_name => "postmaster@sandboxf58a098d874b4185b1d3c993b65ce79f.mailgun.org",
      :password => "890db284410381e1a0bf39d56c9c110d",
      :domain => "sandboxf58a098d874b4185b1d3c993b65ce79f.mailgun.org",
      :authentication => :plain }

  #config.action_mailer.delivery_method = :letter_opener
  #config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.eager_load = false
end
