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

# configure plugins
plugin "validation_reflection", :git => "git://github.com/redinger/validation_reflection.git"

# configure gems manifest (for Heroku)
file ".gems", open("#{repo}/.gems").read

# create base populator
rakefile "populate.rake", open("#{repo}/populate.rake").read

# initializing repository
git :init
git :add => "."
git :commit => %(-m "initial commit")