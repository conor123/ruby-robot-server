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

get '/' do
  'Welcome to Robot Server API!'
end

get '/health' do
  status 200
  json "Healthy"
end

get '/initialize' do

  if (file = File.read 'robots.json')
	  #robots = JSON.load(file, nil, symbolize_names: true)
    # robots.each { |r| 
    # 	robot = Robot.new(r.name, r.status = "ready")
    # 	robot.save
    # }

    robot = Robot.new(name: "Robbie", state: "ready")
    robot.save

	  status 200
	  json "Initialized"
	else
		status 500
	  json "ERROR: problem loading file!"
	end
end

get '/robots' do
  content_type :json
  robots = Robot.all
  robots.to_json

end