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

  post '/notes' do
    binding.pry
    if logged_in?
      @note= Note.new(params[:note])
      @contact = Contact.new(params[:contact]) if !params["contact"]["name"].empty?
      if @note.invalid?
        @note.save
        erb :"/notes/new"
      elsif @contact && @contact.invalid?
        @contact.save if @contact
        erb :'/notes/new'
      elsif @interaction && @interaction.invalid?
        @interaction.save if @interaction
        erb :'/notes/new'
      else
        @note.user = current_user
        @note.save
        redirect to "/notes/#{@note.id}"
      end
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  post '/notes' do
    if logged_in?
      @note= Note.new(params[:note])
      @contact = Contact.new(params[:contact]) if !params["contact"]["name"].empty?
      @interaction = Interaction.new(params[:inteaction]) if !params["interaction"]["date"].empty?
      if @note.invalid?
        @note.save
        erb :"/notes/new"
      elsif @interaction
        if @interaction.invalid?
          @interaction.save
          erb :'/notes/new'
        elsif @interaction.valid? && params["interaction"]["id"]
          erb :"/notes/new", locals: {message: "A note can only be associated with one interaction."}
        elsif @interaction.valid? && !params["interaction"]["id"]
          @note.interaction = @interaction

      elsif @contact
        @contact && params["contact"]["id"]
        erb :"/notes/new", locals: {message: "A note can only be associated with one interaction."}




      
      end
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end
end

      elsif @contact && @contact.invalid?
        @contact.save if @contact
        erb :'/notes/new'
      elsif @interaction && @interaction.invalid?
        @interaction.save if @interaction
        erb :'/notes/new'
      else
        @note.user = current_user

        @note.save
        redirect to "/notes/#{@note.id}"
end