Apipie.configure do |config|
  config.app_name                = "Friends Management API"
  config.app_info                = "Friends Management API Documentation RC1"
  config.api_base_url            = "/api"
  config.doc_base_url            = ''
  config.validate                = false
  config.namespaced_resources    = true

  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"

  config.copyright               = "Ahmad Ramdani 2017"
  config.default_version         = "1.0"
end
