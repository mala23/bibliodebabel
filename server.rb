=begin

Server file, since this app is fairly simple in structure, controllers are also kept in here

=end

require 'sinatra'
require 'data_mapper'
require './app/data_mapper_setup'
require 'haml'
# require './app/helpers/user_helper'
require 'rack-flash'
require_relative './app/helpers/application_helper'

class BDB < Sinatra::Base

  include BensHelper

	set :views, settings.root + '/app/views/'
	set :public_dir, settings.root + '/app/public/'
  set :session_secret, 'ooc-woox-rom-ac'
	enable :sessions
  use Rack::Flash

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
    @user = User.new
    haml :'users/new'
  end

  post '/users' do
    @user = User.new(:email => params[:email],
          :password => params[:password],
          :password_confirmation => params[:password_confirmation])
    # passwords match
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    # passwords don't match
    else
      flash.now[:errors] = @user.errors.full_messages
      haml :'users/new'
    end
  end

  get '/sessions/new' do
    haml :'sessions/new'
  end

  post '/sessions' do
    email, password = params[:email], params[:password]
    user = User.authenticate(email, password)
    if user
      session[:user_id] = user.id
      redirect to('/')
    else
      flash[:errors] = ["The email or password is incorrect"]
      erb :"sessions/new"
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
