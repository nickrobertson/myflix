Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { host: 'sleepy-badlands-5631.herokuapp.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :port => 587,
      :address => "smtp.mailgun.org",
      :user_name => "nbr1983@gmail.com",
      :password => "021583nr",
      :domain => 'sandboxf58a098d874b4185b1d3c993b65ce79f.mailgun.org',
      :authentication => :plain
  }

end
