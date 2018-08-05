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
      erb :'notes/new/for_contact'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  get '/notes/new/for_interaction' do
    if logged_in?
      @user = current_user
      erb :'notes/new/for_interaction'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  get '/notes/:id' do
    if logged_in?
      @note = Note.find(params[:id])
      erb :'notes/show'
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end
  post '/notes/for_contact' do
    if logged_in?
      @note= Note.new(params[:note])
      @contact = Contact.new(params[:contact]) if !params["contact"]["name"].empty?
      if @note.invalid?
        @note.save
        erb :'/notes/new/for_contact'
      elsif @contact && params[:contact][:contact_id]
        erb :'/notes/new/for_contact', locals: {message: "A Note can only belong to one Contact."}
      else
        @contact.notes << @note if @contact
        @note.save
        redirect to "/notes/#{@note.id}"
      end
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  post '/notes/for_contact' do
    
  end

end