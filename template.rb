require 'erb'

#configuration
repo = 'http://github.com/wilkerlucio/rails_template/raw/master'
app_name = @root.split('/').last

# ignoring files
file ".gitignore", open("#{repo}/.gitignore").read

# configure bundler
file "config/boot.rb", open("#{repo}/boot.rb").read
file "config/preinitializer.rb", open("#{repo}/preinitializer.rb").read

# configure gems
file "Gemfile", open("#{repo}/gems").read

# generate things
generate :rspec
generate :cucumber
generate :formtastic
generate :devise_install
generate :nifty_layout, "--haml"

append_file "config/environments/development.rb", "\nconfig.action_mailer.default_url_options = { :host => 'localhost:3000' }"

# factory girl
file "specs/factories.rb", '# put your factories here'

# remove activerecord
gsub_file "config/enviroment.rb",
  '# config.frameworks -= [ :active_record, :active_resource, :action_mailer ]', 'config.frameworks -= [:active_record]'

# configure mongoid
file "config/initializers/mongoid.rb", open("#{repo}/initializers/mongoid.rb").read
file "config/database.mongo.yml", ERB.new(open("#{repo}/database.mongo.yml.erb"), 0, "%<>").result(binding)

# configure sass
file "config/initializers/sass.rb", open("#{repo}/initializers/sass.rb").read

# configure dragonfly
file "config/initializers/dragonfly_images.rb", open("#{repo}/initializers/dragonfly_images.rb").read

# create base populator
rakefile "populate.rake", open("#{repo}/populate.rake").read

# remove old javascript files
run "rm public/javascripts/*"

# add commonly used javascript libraries
file "public/javascripts/jquery-1.4.2.min.js", open("http://code.jquery.com/jquery-1.4.2.min.js").read
file "public/javascripts/jquery.autocomplete.js", open("#{repo}/javascripts/jquery.autocomplete.js").read
file "public/javascripts/jquery.maskedinput-1.2.2.min.js", open("#{repo}/javascripts/jquery.maskedinput-1.2.2.min.js").read
file "public/javascripts/application.js", open("#{repo}/javascripts/application.js").read

# option brazilian configuration
if yes?("Setup pt-br language?")
  # download pt-br i18n and configure environment
  file "config/locales/pt-BR.yml", open("#{repo}/pt-BR.yml").read
  gsub_file "config/environment.rb",
            '# config.i18n.default_locale = :de', 'config.i18n.default_locale = "pt-BR"'
  
  # include webrat br steps
  file "features/step_definitions/webrat_steps_br.rb", open("#{repo}/webrat_steps_br.rb").read
end

# initializing repository
git :init
git :add => "."
git :commit => %(-m "initial commit")