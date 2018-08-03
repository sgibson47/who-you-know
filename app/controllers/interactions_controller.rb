class InteractionsController < ApplicationController
  get '/interactions' do
    if logged_in?
      @user = current_user
      erb :'interactions/index'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  get '/interactions/new' do
    if logged_in?
      erb :'interactions/new'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end
end