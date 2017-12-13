ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../app'

class MainAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # GET /
  def test_api_root
    get '/'
    assert last_response.ok?
    assert_equal 'Welcome to Robot Server API', last_response.body
  end

  # GET /robots
  def test_get_health
    get '/server/health'
    assert last_response.ok?
    assert_equal 'Healthy', last_response.body
  end
  
  # GET /robots
  def test_get_robots
    get '/robots'
    assert_equal 200, last_response.status
  end

  # GET /review/:id
  # def test_get_robot_by_id
  #   #get 'review' , params: {id: 1}
  #   get "/robot/1" #, :id => 1
  #   assert_equal 200, last_response.status
  #   assert_includes last_response.content_type, 'application/json'
  #   assert_includes last_response.body, 'Robbie'

  #   # assert last_response.ok?
  #   # response = JSON.parse(last_response.body)
  #   # assert_equal 5, response.count
  # end

  # DELETE /review/:id
  # def test_delete_robot
  #   delete '/robot/1'
  #   assert_equal 200, last_response.status
  # end
end