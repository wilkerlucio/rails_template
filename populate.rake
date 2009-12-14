namespace :db do
  desc "Erase database data and fill with sample data"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    # do your populator tasks here
  end
end