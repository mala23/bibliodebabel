=begin

Server file, since this app is fairly simple in structure, controllers are also kept in here

=end

require 'sinatra'
require 'data_mapper'
env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bibliodebabel_#{env}")

require './app/models/link'

DataMapper.finalize

DataMapper.auto_upgrade!


class BDB < Sinatra::Base

	set :views, settings.root + '/app/views/'
	set :public_dir, settings.root + '/app/public/'
	enable :sessions
	# set :port, 4567

  get '/' do
    @links = Link.all
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
