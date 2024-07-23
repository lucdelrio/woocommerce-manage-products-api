Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL') }
end

# Sidekiq.configure_server do |mgr|
#   mgr.register("0 1 * * *", "CategoriesCleanupJob") # Category cleanup every day at 1 am
#   mgr.register("10 1 * * *", "ProductsCleanupJob") # Product cleanup every day at 1:10 am
# end

schedule_file = "config/schedule.yml"

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end