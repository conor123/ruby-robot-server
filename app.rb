# app.rb

require 'sinatra'
require 'sinatra/json'
require 'json'
require 'bundler'
Bundler.require
require 'robot'

#DataMapper.setup(:default, 'sqlite::memory:') 
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/data/data.db")
DataMapper.finalize
DataMapper.auto_migrate!

#puts ">>> Running process: #{Process.pid}"

#
# GET /
#
get '/' do
  "Welcome to Robot Server API\n"
end

#
# GET /health
#
get '/server/health' do
	begin ( Robot.all && File.read('robots.json') )
		content_type :json
    # json "Healthy"
    status 200
    "Healthy\n"
  rescue
  	status 503
	  #json "ERROR: problem loading file!"
	  #json review.errors.full_messages
	  "ERROR: Database or Robot file NOT Healthy!\n"
	end
end

#
# GET /initialize
#
get '/initialize' do

  begin (file = File.read 'robots.json')
	  robots = JSON.load(file, nil, symbolize_names: true)
    robots.each { |r| 
    	robot = Robot.new(name: r[:name], state: "ready")
    	robot.save
    }

    # robot = Robot.new(name: "Robbie", state: "ready")
    # robot.save

	  status 200
	  "Initialized\n"
	rescue
		status 500
	  "ERROR: problem loading file!\n"
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
  	# Maybe add time wait here?
  	robot.update(:state => 'started')

  	status 200
    "Started\n"
  else
  	status 400
	  #json robot.errors.full_messages
	  "ERROR: Bad Request Cannot start robot!\n"
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
  	# Maybe add time wait here?
  	robot.update(:state => 'ready')

  	status 200
    "Recharged and Ready\n"
  else
  	status 400
	  #json robot.errors.full_messages
	  "ERROR: Bad Request Cannot recharge robot!\n"
	end
end

#
# GET /robot/stop/:id
#
get '/robot/stop/:id' do
  content_type :json
  robot = Robot.get params[:id]
  robot.to_json
  if robot[:state] == "started"
  	
  	robot.update(:state => 'stopping')
  	# Maybe add time wait here?
  	robot.update(:state => 'ready')

  	status 200
    "Robot stopped! Ready\n"
  else
  	status 400
	  #json robot.errors.full_messages
	  "ERROR: Bad Request Cannot stop robot!\n"
	end
end

#
# GET /server/stop
#
get '/server/stop' do
 #  content_type :json
  begin
		Process.kill("INT", Process.pid)
		status 200
	  "Server stopped! Ready\n"
	rescue
    status 500
	  "ERROR: problem stopping server!\n"
	end

	# end
end

#
# GET /external/script
#
get '/external/script' do
 #  content_type :json
  begin
  	file = "robots.sh"
  	#cmd = "./#{file} Robbie"
  	cmd = "echo hi!!!"
		system(cmd)
		status 200
	  "Script OK! Ready\n"
	rescue
    status 500
	  "ERROR: problem stopping server!\n"
	end

	# end
end