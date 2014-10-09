=begin

Server file, since this app is fairly simple in structure, controllers are also kept in here

=end

require 'sinatra'
require 'data_mapper'
require 'haml'
require './app/helpers/user_helper'
env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bibliodebabel_#{env}")

require './app/models/link'
require './app/models/user'

DataMapper.finalize

DataMapper.auto_upgrade!


class BDB < Sinatra::Base

	set :views, settings.root + '/app/views/'
	set :public_dir, settings.root + '/app/public/'
  set :session_secret, 'ooc-woox-rom-ac'
	enable :sessions

  helpers ApplicationHelpers
	# set :port, 4567

  get '/' do
    @links = Link.all
    haml :index
  end

  post '/link' do
    uri = params["uri"]
    title = params["title"]
    tags = params["tags"].split(" ").map do |tag|
    # this will either find the tag or if nonexisting create it
    Tag.first_or_create(:text => tag)
  end
    Link.create(:uri => uri, :title => title, :tags => tags)
    redirect to('/')
  end

  get '/tags/:text' do
    tag = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    haml :index
  end

  get '/users/new' do
    haml :'users/new'
  end

  post '/users' do
    User.create(:email => params[:email],
          :password => params[:password],
          :password_confirmation => params[:password_confirmation])
    session[:user_id] = User.id
    redirect to('/')
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
