class NotesController < ApplicationController
  get '/notes' do
    redirect_if_not_logged_in
    @user = current_user
    erb :'notes/index'
  end

  get '/notes/new/for_contact' do
    redirect_if_not_logged_in
    @user = current_user
    erb :'notes/new/for_contact'
  end

  get '/notes/new/for_interaction' do
    redirect_if_not_logged_in
    @user = current_user
    erb :'notes/new/for_interaction'
  end

  get '/notes/:id' do
    redirect_if_not_logged_in
    @note = Note.find(params[:id])
    erb :'notes/show'
  end

  post '/notes/for_contact' do
    redirect_if_not_logged_in
    @note= Note.new(params[:note])
    @contact = Contact.new(params[:contact]) if !params["contact"]["name"].empty?
    @user = current_user
    if @note.invalid?
      @note.save
      erb :'/notes/new/for_contact'
    elsif @contact && params[:note][:contact_id]
      erb :'/notes/new/for_contact', locals: {message: "A Note can only belong to one Contact."}
    elsif !@contact && !params[:note][:contact_id]
      erb :'/notes/new/for_contact', locals: {message: "A Note must belong to one Contact."}
    else
      @contact.user = current_user if @contact
      @contact.notes << @note if @contact
      @note.save
      redirect to "/notes/#{@note.id}"
    end
  end

  post '/notes/for_interaction' do
    redirect_if_not_logged_in
    @note= Note.new(params[:note])
    @interaction = Interaction.new(params[:interaction]) if !params["interaction"]["date"].empty?
    @user = current_user
    if @note.invalid?
      @note.save
      erb :'/notes/new/for_interaction'
    elsif @interaction && params[:note][:interaction_id]
      erb :'/notes/new/for_interaction', locals: {message: "A Note can only belong to one Interaction."}
    elsif !@interaction && !params[:note][:interaction_id]
      erb :'/notes/new/for_interaction', locals: {message: "A Note must belong to one Interaction."}
    else
      @interaction.user = current_user if @interaction
      @interaction.notes << @note if @interaction
      @note.save
      redirect to "/notes/#{@note.id}"
    end
  end

  get '/notes/:id/edit' do
    redirect_if_not_logged_in
    @note = Note.find(params[:id])
    @user = current_user
    erb :'notes/edit'
  end

  patch '/notes/:id' do
    redirect_if_not_logged_in
    @note = Note.find(params[:id])
    @user = current_user
    if @note #does the note exist
      if @note.contact #is it a contact's note?
        if @note.contact.user == @user #did this user make the note
          @note.content = params["note"]["content"]
          @note.save
          @contact = Contact.new(params[:contact]) if !params["contact"]["name"].empty?
          if @note.invalid?
            erb :'notes/edit'
          elsif @contact && params[:note][:contact_id] != "nil"
            erb :'/notes/edit', locals: {message: "A Note can only belong to one Contact."}
          elsif !@contact && params[:note][:contact_id] == "nil"
            erb :'/notes/edit', locals: {message: "A Note must belong to one Contact."}
          else
            @note.update(params[:note])
            @contact.user = @user if @contact
            @contact.notes << @note if @contact
            @note.save
            redirect to "/notes/#{@note.id}"
          end
        else
          flash[:message] = "You can only edit your own notes."
          redirect to "/notes"
        end
      elsif @note.interaction 
        if @note.interaction.user == @user #did this user make the note
          @note.content = params["note"]["content"]
          @note.save
          @interaction = Interaction.new(params[:interaction]) if !params["interaction"]["date"].empty?
          if @note.invalid?
            erb :'notes/edit'
          elsif @interaction && params[:note][:interaction_id] != nil
            erb :'/notes/edit', locals: {message: "A Note can only belong to one Interaction."}
          elsif !@interaction && params[:note][:interaction_id] == "nil"
            erb :'/notes/edit', locals: {message: "A Note must belong to one Interaction."}
          else
            @note.update(params[:note])
            @interaction.user = @user if @interaction
            @interaction.notes << @note if @interaction
            @note.save
            redirect to "/notes/#{@note.id}"
          end
        else
          flash[:message] = "You can only edit your own notes."
          redirect to "/notes"
        end
      end
    else
      flash[:message] = "No such note."
      redirect to "/notes"
    end
  end

  delete '/notes/:id/delete' do
    redirect_if_not_logged_in
    @note = Note.find(params[:id])
    if @note 
        if @note.contact
          if @note.contact.user == current_user
            @note.delete
            flash[:message] = "Your note was deleted."
            redirect to "/notes"
          elsif @note.contact.user != current_user
            flash[:message] = "You can only delete your own notes."
            redirect to "/notes"
          end
        elsif @note.interaction
          if @note.interaction.user == current_user
            @note.delete
            flash[:message] = "Your note was deleted."
            redirect to "/notes"
          elsif @note.interaction.user != current_user
            flash[:message] = "You can only delete your own notes."
            redirect to "/notes"
          end
        else
          @note.delete
          flash[:message] = "Your note was deleted."
          redirect to "/notes"
        end
    else
      flash[:message] = "No such note."
      redirect to "/notes"
    end
  end  

end