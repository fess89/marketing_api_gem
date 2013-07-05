$:.push File.expand_path("../lib", __FILE__)
require "marketing_api"

Gem::Specification.new do |s|
  	s.name          = 'marketing_api'
  	s.version       = '0.0.1'
  	s.date          = '2013-07-02'
  	s.summary       = "Working with Marketing class by means of remote API"
    s.description   = "Test task given by Alexander Simonov"
  	s.authors       = ["Oleksii Chyrkov"]
  	s.email         = 'chyrkov@kth.se'
    s.homepage      = ""
	  
    s.files         = `git ls-files`.split("\n")
    s.test_files    = `git ls-files -- spec/*`.split("\n")
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    s.require_paths = ["lib"]

  	s.license      = "MIT"
  	s.platform     = Gem::Platform::RUBY

  	#json is needed to interact with the remote API
	  s.add_runtime_dependency "json"

	  #rspec is only for testing
	  s.add_development_dependency "rspec", "~> 2.13.0" 
	
	  #so is webmock
	  s.add_development_dependency "webmock"
end
