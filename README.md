# Dependency Injection Using `dry-container`

This is an example Sinatra app that uses both [`dry-container`][dry-container]
and [`dry-auto_inject`][dry-auto_inject] to manage dependencies and allow for
swapping them at test time.

## Approach

The application itself is simple -- it's a [Sinatra][] app that exposes a single
endpoint that proxies requests to a configured external host. These parts best
highlight the usage of dependency injection:

- Dependencies are declared in [`Container`](./lib/container.rb) for both the
  [`ProxyClient`](./lib/proxy_client.rb) and environment variables that will be
  used in the main application
- The dependency for the proxy client is automatically injected into
  [`App`](./lib/app.rb) with `dry-auto_inject`
- The test environment specifies a fake
  ([`ProxyClientFake`](./test/support/proxy_client_fake.rb)) with the same
  interface as `ProxyClient` that can be swapped in at test time
- [Testing](./test/app_test.rb) uses `enable_stubs!` on the container to allow
  swapping in the fake proxy client for faking the connection to the external
  service

## Setup

Install the dependencies and start the server

```
bundle && rackup
```

Test the proxy endpoint:

```
curl -s http://localhost:9292/proxy/get | python3 -m json.tool
```

## Testing

You can run the integration tests with [TLDR][]:

```
bundle exec tldr
```

[dry-container]: https://dry-rb.org/gems/dry-container/0.11/
[dry-auto_inject]: https://dry-rb.org/gems/dry-auto_inject/1.0/
[Sinatra]: https://sinatrarb.com/
[TLDR]: https://github.com/tendersearls/tldr
