class ProxyClientFake < ProxyClient
  class Response
    attr_reader :status, :headers, :body

    def initialize(status, headers, body)
      @status = status
      @headers = headers
      @body = StringIO.new(body)
    end
  end

  def initialize
    clear_responses
  end

  def clear_responses
    @responses = []
  end

  def add_response(status, headers, body)
    @responses.push(Response.new(status, headers, body))
  end

  def get(*)
    @responses.shift.tap do |response|
      raise RuntimeError unless response
    end
  end
end
