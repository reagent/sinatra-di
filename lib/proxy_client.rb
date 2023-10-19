class ProxyClient
  def initialize(base_uri:)
    @base_uri = URI(base_uri)
  end

  def get(path)
    uri = @base_uri.dup.tap { |u| u.path = path }
    Response.new(HTTPX.get(uri))
  end

  class Response
    extend Forwardable

    def_delegators :@httpx_response, :status, :headers, :body

    def initialize(httpx_response)
      @httpx_response = httpx_response
    end
  end
end
