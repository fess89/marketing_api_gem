Gem::Specification.new do |s|
  	s.name         = 'marketing_api'
  	s.version      = '0.0.1'
  	s.date         = '2013-07-02'
  	s.summary      = "Working with Marketing class by means of remote API"
    	s.description  = "Test task given by Alexander Simonov"
  	s.authors      = ["Oleksii Chyrkov"]
  	s.email        = 'chyrkov@kth.se'
	s.files        = Dir['lib/**/*.rb']
  	s.require_path = 'lib'
  	s.license      = "MIT"
  	s.platform     = Gem::Platform::RUBY

  	#json is needed to interact with the remote API
	s.add_runtime_dependency "json"

	#rspec is only for testing
	s.add_development_dependency "rspec", "~> 2.13.0" 
	
	#so is webmock
	s.add_development_dependency "webmock"
end