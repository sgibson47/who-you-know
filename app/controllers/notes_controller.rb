class NotesController < ApplicationController
  get '/notes' do
    if logged_in?
      @user = current_user
      erb :'notes/index'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  get '/notes/new/for_contact' do
    if logged_in?
      @user = current_user
      erb :'notes/new'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  get '/notes/new/for_interaction' do
    if logged_in?
      @user = current_user
      erb :'notes/new'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  post '/notes/for_contact' do
    
  end

  post '/notes/for_contact' do
    
  end

end