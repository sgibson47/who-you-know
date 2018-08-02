class ContactsController < ApplicationController
  get '/contacts' do
    if logged_in?
      @user = current_user
      erb :'contacts/index'
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

  get '/contacts/:id' do
    @contact = Contact.find_by_id(params[:id])
    if logged_in? && @contact.user == current_user
      erb :'contacts/show'
    elsif logged_in? && @contact.user != current_user
      erb :'users/show', locals: {message: "You may only view your own contacts."}
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  post '/contacts' do
    if logged_in?
      @contact= Contact.new(params[:contact])
      @note = Note.new(params[:note]) if !params["note"]["content"].empty?
      @note.save if !!@note
      if @contact.invalid?
        erb :"/contacts/new"
      elsif @note && @note.invalid?
        erb :'/contacts/new'
      else
        @contact.user = current_user
        @contact.notes << @note if @note.valid?
        @contact.save
        redirect to "/contacts/#{@contact.id}"
      end
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  get '/contacts/:id/edit' do
    if logged_in?
      @contact = Contact.find_by_id(params[:id])
      if @contact && @contact.user == current_user
        @user = current_user
        erb :'contacts/update'
      elsif @contact && @contact.user != current_user
        @user = current_user
        erb :'contacts/index', locals: {message: "You didn't make that contact. You can't edit other people's contacts."} 
      else
        erb :'contacts/index', locals: {message: "No such contact."}
      end
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

end