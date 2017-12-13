# app.rb

require 'sinatra'
require 'sinatra/json'
require 'json'
require 'bundler'
Bundler.require
require 'robot'

#DataMapper.setup(:default, 'sqlite::memory:') 
DataMapper.setup(:default, 'sqlite:///Users/cr/dev_tests/ruby/robots/data/data.db')
DataMapper.finalize
DataMapper.auto_migrate!

#
# GET /
#
get '/' do
  'Welcome to Robot Server API'
end

#
# GET /health
#
get '/server/health' do
	if Robot.all
		content_type :json
    status 200
  # json "Healthy"
    'Healthy'
  else
  	status 500
	  #json "ERROR: problem loading file!"
	  json review.errors.full_messages
	end
end

#
# GET /initialize
#
get '/initialize' do

  if (file = File.read 'robots.json')
	  robots = JSON.load(file, nil, symbolize_names: true)
    robots.each { |r| 
    	robot = Robot.new(name: r[:name], state: "ready")
    	robot.save
    }

    # robot = Robot.new(name: "Robbie", state: "ready")
    # robot.save

	  status 200
	  json "Initialized"
	else
		status 500
	  json "ERROR: problem loading file!"
	end
end

#
# GET /robots
#
get '/robots' do
  content_type :json
  robots = Robot.all
  robots.to_json

end

#
# GET /robot/:id
#
get '/robot/:id' do
  content_type :json
  review = Robot.get params[:id]
  review.to_json
end


