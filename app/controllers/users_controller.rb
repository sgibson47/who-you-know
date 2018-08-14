class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      flash[:alert] = "Please Log Out to create a new user account."
      redirect to '/'
    else
      erb :'users/signup'
    end
  end

  post '/signup' do
    @user=User.new
    @user.username = params[:username]
    @user.email = params[:email]
    @user.password = params[:password]

    if @user.save
      session[:user_id] = @user.id
      erb :'users/show'
    else
      erb :'users/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      @user = current_user
      erb :'users/show'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      @user = current_user
      erb :'users/show'
    else
      erb :'users/login', locals: {message: "Invalid username & password combo. You must provide an existing username and its password to log in."}
    end
  end

  get '/users/:slug' do
    if logged_in?
      if @user = User.find_by_slug(params[:slug]) 
        if @user == current_user
          erb :'users/show'
        else
          @user = current_user
          erb :'users/show', locals: {message: "You can only view your own content."}
        end
      else
        @user = current_user
        erb :'users/show', locals: {message: "You can only view your own content."}
      end 
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end
  
end