ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../app'

class MainAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  #
  # GET /
  #
  def test_api_root
    get '/'
    assert last_response.ok?
    assert_equal "Welcome to Robot Server API\n", last_response.body
  end

  #
  # GET /server/health
  #
  def test_get_health
    get '/server/health'
    assert last_response.ok?
    assert_equal "Healthy\n", last_response.body
  end
  
  #
  # GET /robots
  #
  def test_get_robots
    get '/robots'
    assert_equal 200, last_response.status
  end

  # DELETE /robot/:id
  # def test_delete_robot
  #   delete '/robot/1'
  #   assert_equal 200, last_response.status
  # end

  #
  # TESTS typical run behaviour
  #
  def test_simulation
    get '/initialize'
    assert_equal 200, last_response.status

    get '/robot/stop/1'
    assert_equal 400, last_response.status
    
    get '/robot/recharge/1'
    assert_equal 200, last_response.status

    get '/robot/start/1'
    assert_equal 200, last_response.status

    get '/robot/recharge/1'
    assert_equal 400, last_response.status

    get '/robot/stop/1'
    assert_equal 200, last_response.status

  end

  def after_all
    get '/server/stop'
    assert_equal 200, last_response.status
  end

end