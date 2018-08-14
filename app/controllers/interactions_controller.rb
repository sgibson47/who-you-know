class InteractionsController < ApplicationController
  get '/interactions' do
    redirect_if_not_logged_in
    @user = current_user
    erb :'interactions/index'
  end

  get '/interactions/new' do
    redirect_if_not_logged_in
    erb :'interactions/new'
  end

  get '/interactions/:id' do
    redirect_if_not_logged_in
    @interaction = Interaction.find_by_id(params[:id])
    if @interaction.user == current_user
      erb :'interactions/show'
    elsif && @interaction.user != current_user
      flash[:message] = "You may only view your own interactions."
      redirect to "/users/#{current_user.slug}"
    end
  end

  post '/interactions' do
    redirect_if_not_logged_in
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
  end

  get '/interactions/:id/edit' do
    redirect_if_not_logged_in
    @interaction = Interaction.find_by_id(params[:id])
    if @interaction && @interaction.user == current_user
      @user = current_user
      erb :'interactions/edit'
    elsif @interaction && @interaction.user != current_user
      flash[:message] = "You may only edit your own interactions."
      redirect to "/users/#{current_user.slug}"
    else
      flash[:message] = "No such interaction."
      redirect to "/interactions"
    end
  end

   patch '/interactions/:id' do
    redirect_if_not_logged_in
    @interaction = Interaction.find(params[:id])
    @note = Note.new(params[:note]) if !params["note"]["content"].empty?
    @contact = Contact.new(params[:contact]) if !params["contact"]["name"].empty?
    if @interaction && @interaction.user != current_user
      flash[:message] = "You may only edit your own interactions."
      redirect to "/users/#{current_user.slug}" 
    elsif @interaction && @interaction.user == current_user
      @interaction.update(params[:interaction])
      if @interaction.invalid?
        @interaction.update(params[:interaction])
        erb :'/interactions/edit'
      elsif @note && @note.invalid?
        @note.save if @note
        erb :'/interactions/edit'
      elsif @contact && @contact.invalid?
        @contact.save
        erb :"/interactions/edit"
      else
        @interaction.notes << @note if @note
        @contact.user = @user if @contact
        @interaction.contacts << @contact if @contact
        @contact.save if @contact
        @interaction.save
        redirect to "/interactions/#{@interaction.id}"
      end
    else
      flash[:message] = "No such interaction."
      redirect to "/interactions"
    end
  end

  delete '/interactions/:id/delete' do
    redirect_if_not_logged_in
    @interaction = Interaction.find(params[:id])
    if @interaction && @interaction.user == current_user
      @interaction.delete
      flash[:message] = "Your interaction was deleted."
      redirect to "/interactions"
    elsif @interaction && @interaction.user != current_user
      flash[:message] = "You may only delete your own interactions."
      redirect to "/users/#{current_user.slug}"
    else
      flash[:message] = "No such interaction."
      redirect to "/interactions"
    end
  end
end