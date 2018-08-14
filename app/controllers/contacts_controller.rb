class ContactsController < ApplicationController
  get '/contacts' do
    redirect_if_not_logged_in
    @user = current_user
    erb :'contacts/index'
  end

  get '/contacts/new' do
    redirect_if_not_logged_in
    erb :'contacts/new'
  end

  get '/contacts/:id' do
    redirect_if_not_logged_in
    @contact = Contact.find_by_id(params[:id])
    if @contact.user == current_user
      erb :'contacts/show'
    elsif @contact.user != current_user
      flash[:message] = "You may only view your own contacts."
      redirect to "/users/#{current_user.slug}" 
    end
  end

  post '/contacts' do
    redirect_if_not_logged_in
    @contact= Contact.new(params[:contact])
    @note = Note.new(params[:note]) if !params["note"]["content"].empty?
    if @contact.invalid?
      @contact.save
      erb :"/contacts/new"
    elsif @note && @note.invalid?
      @note.save
      erb :'/contacts/new'
    else
      @contact.user = current_user
      @note.save if @note
      @contact.notes << @note if @note
      @contact.save
      redirect to "/contacts/#{@contact.id}"
    end
  end

  get '/contacts/:id/edit' do
    redirect_if_not_logged_in
    @contact = Contact.find_by_id(params[:id])
    if @contact && @contact.user == current_user
      @user = current_user
      erb :'contacts/edit'
    elsif @contact && @contact.user != current_user
      flash[:message] = "You may only edit your own contacts."
      redirect to "/users/#{current_user.slug}"
    else
      flash[:message] = "No such contact."
      redirect to "/contacts"
    end
  end

  patch '/contacts/:id' do
    redirect_if_not_logged_in
    @contact = Contact.find(params[:id])
    @note = Note.new(params[:note]) if !params["note"]["content"].empty?
    @interaction = Interaction.new(params[:interaction]) if !params["interaction"]["date"].empty?
    @user = current_user
    if @contact && @contact.user != @user
      flash[:message] = "You can only edit your own contacts."
      redirect to "/contacts"
    elsif @contact && @contact.user == @user
      @contact.update(params[:contact])
      if @contact.invalid?
        erb :"/contacts/edit"
      elsif @note && @note.invalid?
        @note.save if @note
        erb :'/contacts/edit'
      elsif @interaction && @interaction.invalid?
        @interaction.save if @interaction
        erb :'/contacts/edit'
      else
        @contact.notes << @note if @note
        @interaction.user = @user if @interaction
        @contact.interactions << @interaction if @interaction
        @interaction.save if @interaction
        @contact.save
        redirect to "/contacts/#{@contact.id}"
      end
    else
      flash[:message] = "No such contact."
      redirect to "/contacts"
    end
  end

  delete '/contacts/:id/delete' do
    redirect_if_not_logged_in
    @contact = Contact.find(params[:id])
    if @contact && @contact.user == current_user
      @contact.delete
      @user = current_user
      flash[:message] = "Your contact was deleted."
      redirect to "/contacts"
    elsif @cotnact && @contact.user != current_user
      flash[:message] = "You can only delete your own contacts."
      redirect to "/contacts"
    else
      flash[:message] = "No such contact."
      redirect to "/contacts"
    end
  end

end