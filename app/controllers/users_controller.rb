class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      flash[:message] = "Please Log Out to create a new user account."
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
      redirect to "/users/#{@user.slug}"
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
      redirect to "/users/#{current_user.slug}"
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/users/#{current_user.slug}"
    else
      erb :'users/login', locals: {message: "Invalid username & password combo."}
    end
  end

  get '/users/:slug' do
    redirect_if_not_logged_in
    if @user = User.find_by_slug(params[:slug]) 
      if @user == current_user
        erb :'users/show'
      else
        flash[:message] = "You can only view your own content."
        redirect to "/users/#{current_user.slug}"
      end
    else
      flash[:message] = "Not a valid user."
      redirect to '/'
    end 
  end
  
end