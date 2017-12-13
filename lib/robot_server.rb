class RobotServer < RuntimeError
  attr_accessor :config, :robots

  def initialize(robots_file)
  	begin
  		file = File.read config_file
  		@robots = JSON.load(file, nil, symbolize_names: true)
  		system "echo  robots here #{@robots}"

  		@robots.each { |r| 

				robot = Robot.new(name: r[:name], state: "ready", pid: nil)
				robot.save
			}
    rescue => e
    	system "echo #{e}"
    end
    e
  end

  def configure_server
  	
	  
	
  end

  def load_config_file
  end


end