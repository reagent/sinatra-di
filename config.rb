require 'bundler/setup'
require 'sinatra'
require 'dry-container'
require 'dry-auto_inject'
require 'httpx'
require 'uri'

require_relative './lib/container'
require_relative './lib/app'
require_relative './lib/proxy_client'
