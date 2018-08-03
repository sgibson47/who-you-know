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

  get '/interactions/:id' do
    @interaction = Interaction.find_by_id(params[:id])
    if logged_in? && @interaction.user == current_user
      erb :'interactions/show'
    elsif logged_in? && @interaction.user != current_user
      erb :'users/show', locals: {message: "You may only view your own contacts."}
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  post '/interactions' do
    if logged_in?
      @interaction= Interaction.new(params[:interaction])
      @note = Note.new(params[:note]) if !params["note"]["content"].empty?
      if @interaction.invalid?
        @interaction.save
        erb :"/interactions/new"
      elsif @note && @note.invalid?
        @note.save if !!@note
        erb :'/interactions/new'
      else
        @interaction.user = current_user
        @note.save if !!@note
        @interaction.notes << @note if @note
        @interaction.save
        redirect to "/interactions/#{@interaction.id}"
      end
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  get '/interactions/:id/edit' do
    if logged_in?
      @interaction = Interaction.find_by_id(params[:id])
      if @interaction && @interaction.user == current_user
        @user = current_user
        erb :'interactions/edit'
      elsif @interaction && @interaction.user != current_user
        @user = current_user
        erb :'interactions/index', locals: {message: "You didn't make that interaction. You can't edit other people's interactions."} 
      else
        @user = current_user
        erb :'interactions/index', locals: {message: "No such interaction."}
      end
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

   patch '/interactions/:id' do
    if logged_in?
      @interaction = Interaction.find(params[:id])
      @note = Note.new(params[:note]) if !params["note"]["content"].empty?
      @contact = Contact.new(params[:contact]) if !params["contact"]["name"].empty?
      if @interaction && @interaction.user != current_user
        @user = current_user
        erb :'interactions/index', locals: {message: "You didn't make that contact. You can't edit other people's contacts."} 
      elsif @interaction && @interaction.user == current_user
        if @interaction.invalid?
          @interaction.update(params[:interaction])
          erb :'/interactions/new'
        elsif @note && @note.invalid?
          @note.save if @note
          erb :'/interactions/new'
        elsif @contact && @contact.invalid?
          @contact.save
          erb :"/interactions/new"
        else
          @interaction.update(params[:interaction])
          @interaction.notes << @note if @note
          @interaction.contacts << @contact if @contact
          @interaction.save
          redirect to "/interactions/#{@interaction.id}"
        end
      else
        @user = current_user
        erb :'interactions/index', locals: {message: "No such contact."}
      end
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end

  delete '/interactions/:id/delete' do
    if logged_in?
      @interaction = Interaction.find(params[:id])
      if @interaction && @interaction.user == current_user
        @interaction.delete
        @user = current_user
        erb :'interactions/index', locals: {message: "Your interaction was deleted."}
      elsif @interaction && @interaction.user != current_user
        @user = current_user
        erb :'interactions/index', locals: {message: "You didn't make that interaction. You can't delete other people's interactions."} 
      else
        @user = current_user
        erb :'interactions/index', locals: {message: "No such interaction."}
      end
    else
      erb :'users/login', locals: {message: "Please sign in to view content."}
    end
  end
end