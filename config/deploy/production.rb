server '35.72.58.63', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/Users/isajikuniyuki/.ssh/id_rsa'

credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
Aws::Rails.add_action_mailer_delivery_method(
  :ses, 
  credentials:, # Ruby 3.1の文法
  region: 'ap-northeast-1'
)

config.action_mailer.default_url_options = { host: 'imeezi.com' }
config.action_mailer.delivery_method = :ses
config.action_mailer.perform_deliveries = true
config.action_mailer.perform_caching = false
config.action_mailer.raise_delivery_errors = true