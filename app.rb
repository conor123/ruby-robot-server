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
#DataMapper.auto_migrate!
#DataMapper.auto_upgrade!

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
    	robot = Robot.new(name: r[:name], state: "ready", pid: nil)
    	robot.save
    }

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
  	robot.update!(:state => 'starting')
  	
  	# To test intermidiate states
  	system("echo sleeping 3s...")
  	sleep 3

  	robot = Robot.get! params[:id]
	  robot.to_json

	  if robot[:state] == "starting"

  	  robot.update!(:state => 'started')
  	  status 200
      "Started\n"
  	else
  		status 400
		  "ERROR: Bad Request Cannot start robot!\n"
		end
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
  elsif robot[:state] == "stopping"
  	robot.update(:state => 'ready')
  	robot.update(:state => 'recharging')
  	# Maybe add time wait here?
  	robot.update(:state => 'ready')

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
  if ( robot[:state] == "started" || robot[:state] == "starting" )
  	
  	robot.update!(:state => 'stopping')

  	# Maybe add time wait here?
  	robot.update!(:state => 'ready')

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
end

#
# GET /external/script
#
get '/external/robot/start/:id' do
  robot = Robot.get params[:id]
  robot.to_json
  #if robot[:state] == "ready"
  #robot.update(:state => 'recharging')
  #  content_type :json
  begin
  	file = "#{Dir.pwd}/robots.sh"
  	#cmd = "echo #{file}"
  	cmd = "bash #{file} #{robot[:name]} &"
    pid = nil

    tid = Thread.new do 
      pid = Process.spawn do
        system( cmd )
        system("echo here!")
        robot.update(:pid => pid)
        # Process.detach pid
        # status = Process.wait(pid, 0)
      end
    end
    
    robot.update(:pid => tid)

		status 200
	  "Script OK! PID is #{pid}, TID is #{tid}\n"
	rescue
    status 500
	  "ERROR: problem running script!\n"
	end

	# end
end

#
# GET /external/script
#
get '/external/robot/stop/:id' do

  robot = Robot.get params[:id]
  robot.to_json
  pid = robot[:pid]

  system("echo Robot id: #{pid}\n")

  # system("echo Status: #{status} sleeping 3s...")
  # sleep 3

  # Process.kill("INT", pid)
  
end