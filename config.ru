require 'sidekiq'
require 'sidekiq/web'
require 'dotenv'
Dotenv.load

Sidekiq.configure_client do |config|
  config.redis = { size: 1, url: ENV['REDIS_URL'], namespace: 'workers' }
end

map '/' do
  use Rack::Auth::Basic, 'GSC developers only' do |username, password|
    username == ENV['USERNAME'] && password == ENV['PASSWORD']
  end

  run Sidekiq::Web
end

