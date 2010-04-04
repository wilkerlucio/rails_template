require 'erb'

#configuration
repo = 'http://github.com/wilkerlucio/rails_template/raw/master'
app_name = @root.split('/').last

# ignoring files
file ".gitignore", open("#{repo}/.gitignore").read

# configure gems
gem "bistro_car"
gem "will_paginate"
gem "inherited_resources", :version => "1.0.3"
gem "has_scope",           :version => "0.4.2"
gem "responders",          :version => "0.4.6"
gem "haml"
gem "formtastic"
gem "rails-footnotes"
gem "mongoid"
gem "rpx_now"
gem "devise"
gem "cucumber", :lib => false
gem "cucumber-rails", :lib => false
gem "rspec", :lib => false
gem "rspec-rails", :lib => false
gem "webrat"

# generate things
generate :rspec
generate :cucumber
generate :formtastic
generate :devise_install

append_file "config/environments/development.rb", "\nconfig.action_mailer.default_url_options = { :host => 'localhost:3000' }"

# configure mongoid
file "config/initializers/mongoid.rb", open("#{repo}/initializers/mongoid.rb")
file "config/database.mongo.yml", ERB.new(open("#{repo}/database.mongo.yml.erb"), 0, "%<>").result(binding)
gsub_file "config/environment.rb",
          'end', "  config.after_initialize do\n    RPXNow.api_key = \"YOUR_APP_ID\"\n  end\nend"

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