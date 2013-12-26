class NotesController < ApplicationController
  def index
    @notes = @@neo.execute_query("MATCH (n:Note) RETURN n")["data"]
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @note = @@neo.execute_query("MATCH (n:Note) WHERE n.uid=\"#{params[:id]}\" RETURN n")["data"][0][0]["data"]
    @suggested_notes = @@neo.execute_query("START n = node(*) WHERE n.uid = \"#{params[:id]}\" MATCH n-[:contains]->friend-[:comprises]->friend_of_friend WHERE NOT(friend_of_friend.uid = n.uid) AND NOT(n-[:linked]->friend_of_friend)  RETURN collect(friend.str), friend_of_friend.body, friend_of_friend.uid")["data"]
    @linked_notes = @@neo.execute_query("START n = node(*) WHERE n.uid = \"#{params[:id]}\" MATCH n-[:linked]->friend RETURN  friend.body, friend.uid")["data"]
    render :layout => false
  end

  def new
     @notes = Note.new
  end

  def create
  end

  def edit
  end

  def delete
  end

end
