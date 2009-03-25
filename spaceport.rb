# SpacePort )))=> a Compilation Rails 2.3.2 Template
# Based on bort.rb => from Jeremy McAnally, Pratik Naik
# Based on daring.rb => from Peter Cooper
# Based on bort by Jim Neath
 
# Delete unnecessary files
  run "rm README"
  run "rm public/index.html"
  run "rm public/favicon.ico"
  run "rm public/robots.txt"
  run "rm -f public/javascripts/*"
 
# Download JQuery
  run "curl -L http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js > public/javascripts/jquery.js"
  run "curl -L http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.1/jquery-ui.min.js > public/javascripts/jquery-ui.js"
 
# Set up git repository
  git :init
  git :add => '.'
  
# Copy database.yml for distribution use
  run "cp config/database.yml config/database.yml.example"
  
# Set up .gitignore files
  run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
  run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
  file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END
 
# Install submoduled plugins
  plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git', :submodule => true
  plugin 'exception_notifier', :git => 'git://github.com/rails/exception_notification.git', :submodule => true
  plugin "jrails", :git => 'git://github.com/aaronchi/jrails.git', :submodule => true
  plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git', :submodule => true
  plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git', :submodule => true
  plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git', :submodule => true
  plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git', :submodule => true  
 
# Install all gems
  gem 'RedCloth', :lib => 'redcloth'
  gem 'mislav-will_paginate', :version => '~> 2.2.3', :lib => 'will_paginate', :source => 'http://gems.github.com'
  gem 'rubyist-aasm', :version => '~> 2.0.5', :lib => 'aasm'
  
  rake 'asset:packager:create_yml'
 
#create Root Controller
if yes?("Do you want a root controller?")
  generate :controller, "welcome index"
  route "map.root :controller => 'welcome'"
end

#create Auth Routes
  route "map.signup  '/signup', :controller => 'users', :action => 'new'"
  route "map.login  '/login',  :controller => 'session', :action => 'new'"
  route "map.logout '/logout', :controller => 'session', :action => 'destroy"

# Initialize submodules
git :submodule => "init"
 
# Commit all work so far to the repository
git :add => '.'
git :commit => "-a -m 'Initial Countdown'"

# Success!
puts "Lift Off!"