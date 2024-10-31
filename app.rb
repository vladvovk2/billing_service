require 'bundler'
require 'bundler/setup'
Bundler.require

require_relative 'config/environment.rb'

class App < Sinatra::Base
  use ApplicationController
  use SubscriptionsController

  get '/' do
    'Hello, world!'
  end
end
