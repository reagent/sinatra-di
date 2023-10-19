class Container
  extend Dry::Container::Mixin

  register :env do
    Dotenv.parse
  end

  register :proxy_client do
    ProxyClient.new(base_uri: resolve(:env).fetch('BASE_URI'))
  end
end
