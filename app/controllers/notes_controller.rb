class NotesController < ApplicationController
  get '/notes' do
    if logged_in?
      @user = current_user
      erb :'notes/index'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end
end