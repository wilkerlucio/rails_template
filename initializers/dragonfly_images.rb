# Configuration
File.open(File.join(RAILS_ROOT, 'config/database.mongo.yml'), 'r') do |f|
  @settings = YAML.load(f)[RAILS_ENV]
end

app = Dragonfly::App[:images]
app.configure_with(Dragonfly::RMagickConfiguration)
app.datastore = Dragonfly::DataStorage::MongoGridFsStore.new @settings["host"], @settings["database"]
app.defaults_path = File.join(RAILS_ROOT, %w[public images])
app.configure do |c|
  c.log = Rails.logger
  c.url_handler.configure do |u|
    u.secret = 'ce61f1fdfef4b467a9b559d37c6bd28c9453ff08'
    u.path_prefix = '/media'
  end
end

# Add the Dragonfly App to the middleware stack
ActionController::Dispatcher.middleware.insert_after ActionController::Failsafe, Dragonfly::Middleware, :images

# Plug Mongoid Extensions
Mongoid::Document::InstanceMethods.module_eval do
  def self.included(base)
    base.extend Dragonfly::MongoidExtensions::ClassMethods
    base.send :include, Dragonfly::MongoidExtensions::InstanceMethods
    base.register_dragonfly_app :image, Dragonfly::App[:images]
  end
end

# UNCOMMENT THIS IF YOU WANT TO CACHE REQUESTS WITH Rack::Cache, and add the line
#   config.gem 'rack-cache', :lib => 'rack/cache'
# to environment.rb
require 'rack/cache'
ActionController::Dispatcher.middleware.insert_before Dragonfly::Middleware, Rack::Cache, {
  :verbose     => true,
  :metastore   => "file:#{Rails.root}/tmp/dragonfly/cache/meta",
  :entitystore => "file:#{Rails.root}/tmp/dragonfly/cache/body"
}
