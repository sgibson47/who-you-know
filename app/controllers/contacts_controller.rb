class ContactsController < ApplicationController
  get '/contacts' do
    if logged_in?
      @user = current_user
      erb :'contacts/index'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  get '/contacts/:id' do
    @contact = Contact.find_by_id(params[:id])
    if logged_in? && @contact.user == current_user
      erb :'cotnacts/show'
    elsif logged_in? && @contact.user != current_user
      erb :'users/show', locals: {message: "You may only view your own contacts."}
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  get '/contacts/new' do
    if logged_in?
      erb :'contacts/new'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

end