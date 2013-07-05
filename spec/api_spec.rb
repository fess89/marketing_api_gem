require 'webmock/rspec'
require 'json'
require 'spec_helper'
require 'marketing_api'

describe MarketingAPI, "#marketing_remote_api" do

	api = MarketingAPI.new
	WebMock.disable_net_connect!

	success_reply = 
	{
		"id"=>21, "email"=>"chyrkov@kth.se", 
		"mobile"=>"380632721593", "first_name"=>"Oleksii", 
		"last_name"=>"Chyrkov", "permission_type"=>"one-time", 
		"channel"=>"sms", "company_name"=>"Apple", 
		"message"=>"Found optin", "code"=>200
	}

	not_found_reply = 
	{
		"code"=> 404, 
		"message"=>"Optin not found"
	}

	bad_request_reply = 
	{
		"code"=> 401, 
		"message"=>"Bad request"
	}

	already_exists_reply = 
	{
		"code"=> 302, 
		"message"=>"Bad request"
	}

	params = 
	{ 	
		:email => "chyrkov@kth.se",
		:mobile => "380632721593",
		:company_name => "Apple",
		:first_name => "Oleksii",
		:last_name => "Chyrkov",
		:permission_type => "one-time",
		:channel => "sms"
	}

	#TODO: return JSON here
	it "should return valid JSON when getting an existing Optin" do
		id = rand(10)
		stub_request(:get, "#{api.server}:#{api.port}/#{id}").to_return(
																:status => 200,
																:body => success_reply)
		json = api.get_optin(id).to_json
		#JSON validation is defined in the helper
		json.valid_json?.should eq(true)
	end

	it "should return true when creating an Optin with good params" do
	 	stub_request(:post, api.server+":80/create").with(:body => params.to_json)
	 												.to_return(:status => 200, :body => success_reply)
		api.create_optin(params.to_json).should eq(true)
	end

	it "should return true when updating an existing Optin" do
		params[:id] = rand(10)
		stub_request(:post, api.server+":80/update").with(:body => params.to_json)
	 													  .to_return(:status => 200, 
	 													  			 :body => success_reply)
		api.update_optin(params.to_json).should eq(true)
	end

	it "should return true when deactivating an existing Optin" do
		id = rand(10)
		success_reply = 
		{
			:message => "Optin with id #{id} deactivated",
			:code => 200
		}
		stub_request(:post, api.server+":80/deactivate/#{id}").to_return(:status => 200, 
																:body => success_reply)
		api.deactivate_optin(id).should eq(true)
	end

	it "should return nil when creating from invalid JSON" do
		#random string instead of JSON request
		request = (0..60).map{ ('a'..'z').to_a[rand(26)] }.join
		stub_request(:post, api.server+":80/create").with(:body => request)
	 												.to_return(:status => 503, 
	 														   :body => bad_request_reply)
		api.create_optin(request).should eq(nil)
	end

	it "should return nil when updating from invalid JSON" do
		#random string instead of JSON request
		request = (0..60).map{ ('a'..'z').to_a[rand(26)] }.join
		stub_request(:post, api.server+":80/update").with(:body => request)
	 												.to_return(:status => 503, 
	 														   :body => bad_request_reply)
		api.update_optin(request).should eq(nil)
	end

	it "should return nil when creating an Optin with no email" do
		params[:email] = ""
		stub_request(:post, api.server+":80/create").with(:body => params.to_json)
													.to_return(:status => 404, :body => bad_request_reply)
		api.create_optin(params.to_json).should eq(nil)
	end

	it "should return nil when creating an Optin with no company name" do
		params[:company_name] = ""
		stub_request(:post, api.server+":80/create").with(:body => params.to_json)
													.to_return(:status => 404, :body => bad_request_reply)
		api.create_optin(params.to_json).should eq(nil)
	end


	it "should return nil when creating an Optin with no first name" do
		params[:first_name] = nil		
		stub_request(:post, api.server+":80/create").with(:body => params.to_json)
													.to_return(:status => 404, :body => bad_request_reply)
		api.create_optin(params.to_json).should eq(nil)
	end

	it "should return nil when creating an Optin with no last name" do
		params[:last_name] = nil
		stub_request(:post, api.server+":80/create").with(:body => params.to_json)
													.to_return(:status => 404, :body => bad_request_reply)
		api.create_optin(params.to_json).should eq(nil)
	end

	it "should return nil when creating an Optin with wrong permission type" do
		#random string in permission type
		params[:permission_type] = (0..9).map{ ('a'..'z').to_a[rand(26)] }.join
		stub_request(:post, api.server+":80/create").with(:body => params.to_json)
													.to_return(:status => 404, :body => bad_request_reply)
		api.create_optin(params.to_json).should eq(nil)
	end

	it "should return nil when creating an Optin with wrong channel" do
		#random string in channel
		params[:channel] = (0..9).map{ ('a'..'z').to_a[rand(26)] }.join
		stub_request(:post, api.server+":80/create").with(:body => params.to_json)
													.to_return(:status => 404, :body => bad_request_reply)
		api.create_optin(params.to_json).should eq(nil)
	end

	it "should return nil when getting a non-existent Optin" do
		#IDs so big probably do not exist
		id = rand(30000..40000)
		stub_request(:get, "#{api.server}:#{api.port}/#{id}").to_return(
																:status => 404,
																:body => not_found_reply)
		api.get_optin(id).should eq(nil)
	end

	it "should return nil when updating a non-existent Optin" do
		params[:id] = rand(30000..40000).to_s
		stub_request(:post, api.server+":80/update").with(:body => params.to_json)
	 												.to_return(:status => 404,
															   :body => not_found_reply)
		api.update_optin(params.to_json).should eq(nil)
	end

	it "should return nil when deactivating a non-existent Optin" do
		id = rand(30000..40000)
		stub_request(:post, api.server+":80/deactivate/#{id}").to_return(:status => 404,
															   			 :body => not_found_reply)
		api.deactivate_optin(id).should eq(nil)
	end

	it "should return nil when creating a duplicate company/channel pair Optin" do
		params[:id] = rand(10)
		stub_request(:post, api.server+":80/update").with(:body => params.to_json)
	 												.to_return(:status => 200, :body => success_reply)
		api.update_optin(params.to_json).should eq(true)
		stub_request(:post, api.server+":80/update").with(:body => params.to_json)
	 												.to_return(:status => 302,
															   :body => already_exists_reply)
		api.update_optin(params.to_json).should eq(nil)
	end

end