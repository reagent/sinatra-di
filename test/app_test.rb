require_relative '../config'

require 'tldr'
require 'rack/test'
require 'dry/container/stub'

require_relative './support/proxy_client_fake'

class AppTest < TLDR
  include Rack::Test::Methods

  attr_reader :app

  def setup
    @proxy_client = ProxyClientFake.new

    Container.enable_stubs!
    Container.stub(:proxy_client, @proxy_client)

    @app = App.new
  end

  def test_successful_response
    @proxy_client.add_response(
      200,
      { 'Content-Type' => 'application/json' },
      JSON.generate({ key: 'value' })
    )

    get '/proxy/get'

    last_response.tap do |response|
      assert_equal(200, response.status)
      assert_equal('application/json', response.headers['Content-Type'])
      assert_equal({ 'key' => 'value' }, JSON.parse(response.body))
    end
  end

  def test_failed_response
    @proxy_client.add_response(
      401,
      { 'Content-Type': 'application/json' },
      JSON.generate({ 'message': 'Unauthorized' })
    )

    get '/proxy/get'

    last_response.tap do |response|
      assert_equal(401, response.status)
      assert_equal({ 'message' => 'Unauthorized' }, JSON.parse(response.body))
    end
  end

  def test_multiple_responses
    @proxy_client.add_response(200, {}, 'body')
    @proxy_client.add_response(400, {}, 'oops')

    get '/proxy/get'

    assert_equal(200, last_response.status)

    get '/proxy/get'

    assert_equal(400, last_response.status)
  end
end
