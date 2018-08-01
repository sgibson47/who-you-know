class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      erb :'users/show', , locals: {message: "Please Log Out to create a new user account."}
    else
      erb :'/users/signup'
    end
  end
  
end