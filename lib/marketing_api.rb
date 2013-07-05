require 'net/http'
require 'uri'

class MarketingAPI 

	attr_accessor :server, :port

	def initialize(server="web.ict.kth.se/~chyrkov", port=80)
		@server = server
		@port = port
	end

	#it is easy to go with get
	def get_optin(id)
		uri = URI.parse("http://web.ict.kth.se/~chyrkov:80/#{id}")
		response = Net::HTTP.get_response(uri)
		if response.code == "200"
			return response.body
		else
			return nil
		end
	end

	def create_optin(json_string)
		req = Net::HTTP::Post.new("/create", initheader = {'Content-Type' =>'application/json'})
		req.body = json_string
		response = Net::HTTP.new(@server, @port).start {|http| http.request(req) }
		if response.code == "200"
			return true
		else
			return nil
		end
	end

	def update_optin(json_string)
		req = Net::HTTP::Post.new("/update", initheader = {'Content-Type' =>'application/json'})
		req.body = json_string
		response = Net::HTTP.new(@server, @port).start {|http| http.request(req) }
		if response.code == "200"
			return true
		else
			return nil
		end
	end

	def deactivate_optin(id)
		req = Net::HTTP::Post.new("/deactivate/#{id}", initheader = {'Content-Type' =>'application/json'})
		response = Net::HTTP.new(@server, @port).start {|http| http.request(req) }
		if response.code == "200"
			return true
		else
			return nil
		end
	end
end