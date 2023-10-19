Import = Dry::AutoInject(Container)

class App < Sinatra::Base
  include Import['proxy_client']

  get '/proxy/:path' do
    response = proxy_client.get("/#{params[:path]}")
    [response.status, response.headers, response.body.read]
  end
end
