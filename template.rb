#configuration
repo = 'http://github.com/wilkerlucio/rails_template/raw/master'

# ignoring files
file ".gitignore", open("#{repo}/.gitignore").read

# download pt-br i18n and configure environment
file "config/locales/pt-BR.yml", open("#{repo}/pt-BR.yml").read
gsub_file "config/environment.rb",
          '# config.i18n.default_locale = :de', 'config.i18n.default_locale = "pt-BR"'

# configure gems
gem "authlogic"
gem "searchlogic"
gem "mislav-will_paginate", :lib => 'will_paginate', :source => 'http://gems.github.com'
gem "josevalim-inherited_resources", :lib => "inherited_resources", :source => "http://gems.github.com"
gem "justinfrench-formtastic", :lib => 'formtastic', :source => 'http://gems.github.com'
gem "rails-footnotes", :source => "http://gemcutter.org"
gem "cucumber", :lib => false
gem "cucumber-rails", :lib => false
gem "rspec", :lib => false
gem "rspec-rails", :lib => false
gem "webrat"

# configure plugins
plugin "validation_reflection", :git => "git://github.com/redinger/validation_reflection.git"

# configure rspec and cucumber
generate :rspec
generate :cucumber

# include webrat br steps
file "features/step_definitions/webrat_steps_br.rb", open("#{repo}/webrat_steps_br.rb").read

# configure gems manifest (for Heroku)
file ".gems", open("#{repo}/.gems").read

# create base populator
rakefile "populate.rake", open("#{repo}/populate.rake").read

# remove old javascript files
run "rm public/javascripts/*"

# add commonly used javascript libraries
file "public/javascripts/jquery-1.4.1.min.js", open("http://code.jquery.com/jquery-1.4.1.min.js").read
file "public/javascripts/jquery.autocomplete.js", open("#{repo}/javascripts/jquery.autocomplete.js").read
file "public/javascripts/jquery.maskedinput-1.2.2.min.js", open("#{repo}/javascripts/jquery.maskedinput-1.2.2.min.js").read
file "public/javascripts/application.js", open("#{repo}/javascripts/application.js").read

# initializing repository
git :init
git :add => "."
git :commit => %(-m "initial commit")