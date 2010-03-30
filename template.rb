#configuration
repo = 'http://github.com/wilkerlucio/rails_template/raw/master'

# ignoring files
file ".gitignore", open("#{repo}/.gitignore").read

# configure gems
gem "bistro_car"
gem "mislav-will_paginate", :lib => 'will_paginate', :source => 'http://gems.github.com'
gem "josevalim-inherited_resources", :lib => "inherited_resources", :source => "http://gems.github.com"
gem "justinfrench-formtastic", :lib => 'formtastic', :source => 'http://gems.github.com'
gem "rails-footnotes", :source => "http://gemcutter.org"
gem "cucumber", :lib => false
gem "cucumber-rails", :lib => false
gem "rspec", :lib => false
gem "rspec-rails", :lib => false
gem "webrat"

# configure rspec and cucumber
generate :rspec
generate :cucumber

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