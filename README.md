marketing_api_gem
=================

The gem is used as a remote API (using Net::HTTP) for the service called marketing (https://github.com/fess89/marketing). 

Installation for production
---------------------------
gem install marketing_api

Installation for testing
------------------------
mkdir marketing_api_gem

cd marketing_api_gem

git clone https://github.com/fess89/marketing_api_gem .

rake build

gem install rspec

gem install webmock

Testing
-------
rake 




