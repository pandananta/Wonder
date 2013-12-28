class NotesController < ApplicationController
  before_filter :download_notebook  

  def download_notebook
    @notes = @@neo.execute_query("MATCH (n:Note) RETURN n")["data"]
  end

  def index    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @note = @@neo.execute_query("MATCH (n:Note) WHERE n.uid=\"#{params[:id]}\" RETURN n")["data"][0][0]["data"]
    @suggested_notes = @@neo.execute_query("START n = node(*) WHERE n.uid = \"#{params[:id]}\" MATCH n-[:contains]->friend-[:comprises]->friend_of_friend WHERE NOT(friend_of_friend.uid = n.uid) AND NOT(n-[:linked]->friend_of_friend)  RETURN collect(friend.str), friend_of_friend.prompt, friend_of_friend.uid")["data"]
    @linked_notes = @@neo.execute_query("START n = node(*) WHERE n.uid = \"#{params[:id]}\" MATCH n-[:linked]->friend RETURN  friend.prompt, friend.uid")["data"]
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new
    @note.prompt = params[:note]["prompt"] 
    @note.body = params[:note]["body"] 
    # = Note.new(params[:note])
    
    respond_to do |format|
      if @note.save
        format.html { redirect_to "/notes/#{@note.uid}"}
      else
        format.html { render action: "new" }
      end
    end

  end

  def edit
  end

  def delete
  end

end
