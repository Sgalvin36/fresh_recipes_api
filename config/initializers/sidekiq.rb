Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'], namespace: 'whispering-thicket-76959' }
end

Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'], namespace: 'whispering-thicket-76959' }
end