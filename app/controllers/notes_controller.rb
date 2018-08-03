class NotesController < ApplicationController
  get '/notes' do
    if logged_in?
      @user = current_user
      erb :'notes/index'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  get '/notes/new' do
    if logged_in?
      @user = current_user
      erb :'notes/new'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end
end