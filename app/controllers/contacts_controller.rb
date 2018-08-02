class ContactsController < ApplicationController
  get '/contacts' do
    if logged_in?
      @user = current_user
      erb :'contacts/show'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end
end