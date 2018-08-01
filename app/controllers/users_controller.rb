class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      @user = current_user
      erb :'users/show', locals: {message: "Please Log Out to create a new user account."}
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
  
end