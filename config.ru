require 'sinatra'

set :environment, :production

require 'app'

run Sinatra::Application
