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
end