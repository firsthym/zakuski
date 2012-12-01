require 'rubygems'
#require 'mongo'
#source "http://ruby.taobao.org"
#source 'http://gemcutter.org'
source 'https://rubygems.org'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'rails', '3.2.5'
gem 'rails-i18n'
gem 'jquery-rails'

# mongo database and the ODM
gem 'mongoid'

gem 'bootstrap-sass', '~>2.1.0.0'
gem 'bcrypt-ruby', '3.0.1'

# User Authentication & Authorization
gem 'devise'
# paginate
gem 'kaminari'

# web server
gem 'thin', '~>1.4.1'

# upload
gem "carrierwave-mongoid", :git => "git://github.com/jnicklas/carrierwave-mongoid.git", 
    :branch => "mongoid-3.0", :require => 'carrierwave/mongoid'
gem 'mini_magick','3.3'

# markdown
gem "redcarpet"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.4'
  gem 'coffee-rails', '3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
	gem 'rspec-rails', '~>2.10.0'
	gem 'factory_girl_rails'
	gem 'database_cleaner'
	gem "capybara"
  gem "spork-rails"
  gem 'faker', '1.0.1'
  gem 'launchy'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
