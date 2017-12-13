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
    # json "Healthy"
    status 200
    'Healthy'
  else
  	status 503
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
  robot = Robot.get params[:id]
  robot.to_json
end

#
# GET /robot/start/:id
#
get '/robot/start/:id' do
  content_type :json
  robot = Robot.get params[:id]
  robot.to_json
  if robot[:state] == "ready"
  	
  	robot.update(:state => 'starting')
  	robot.update(:state => 'started')

  	status 200
    'Started'
  else
  	status 400
	  json review.errors.full_messages
	end
end

#
# GET /robot/recharge/:id
#
get '/robot/recharge/:id' do
  content_type :json
  robot = Robot.get params[:id]
  robot.to_json
  if robot[:state] == "ready"
  	
  	robot.update(:state => 'recharging')
  	robot.update(:state => 'recharged')

  	status 200
    'Recharged'
  else
  	status 400
	  json review.errors.full_messages
	end
end
