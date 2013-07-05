require 'net/http'
require 'uri'

class MarketingAPI 

	attr_accessor :server, :port

	# Initializes the API with optional server and port
	# The protocol is HTTP and it cannot be changed
	def initialize(server="web.ict.kth.se/~chyrkov", port=80)
		@server = server
		@port = port
	end

	# Validates URI based on @server and @port
	def uri_valid?
		URI.parse("http://#{@server}:#{@port}")
		return true
		rescue URI::InvalidURIError => err
			return nil
	end

	# Gets an optin
	# Params: 
	# +id:: ID of the optin in the DB
	# Returns optin as JSON if it is found, nil otherwise
	def get_optin(id)
		if !uri_valid?
			return nil
		end
		uri = URI.parse("http://#{@server}:#{@port}/#{id }")
		response = Net::HTTP.get_response(uri)
		if response.code == "200"
			return response.body
		else
			return nil
		end
	end

	# Creates an optin from JSON
	# Returns true if it is created, nil otherwise
	# Params:
	# +json_string:: JSON to turn into an optin
	def create_optin(json_string)
		if !uri_valid?
			return nil
		end
		req = Net::HTTP::Post.new("/create", initheader = {'Content-Type' =>'application/json'})
		req.body = json_string
		response = Net::HTTP.new(@server, @port).start {|http| http.request(req) }
		if response.code == "200"
			return true
		else
			return nil
		end
	end

	# Updates an optin from JSON
	# Returns true if it is updated, nil if optin is not found or update failed
	# Params:
	# +json_string:: JSON to turn into an optin
	def update_optin(json_string)
		if !uri_valid?
			return nil
		end
		req = Net::HTTP::Post.new("/update", initheader = {'Content-Type' =>'application/json'})
		req.body = json_string
		response = Net::HTTP.new(@server, @port).start {|http| http.request(req) }
		if response.code == "200"
			return true
		else
			return nil
		end
	end

	# Deactivates an optin
	# Params: 
	# +id:: ID of the optin in the DB
	# Returns true if optin is deactivated, nil if optin is not found or deactivation failed
	def deactivate_optin(id)
		if !uri_valid?
			return nil
		end
		req = Net::HTTP::Post.new("/deactivate/#{id}", initheader = {'Content-Type' =>'application/json'})
		response = Net::HTTP.new(@server, @port).start {|http| http.request(req) }
		if response.code == "200"
			return true
		else
			return nil
		end
	end
end