class NotesController < ApplicationController
  def index
    @notes = @@neo.execute_query("MATCH (n:Note) RETURN n")["data"]
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @note = @@neo.execute_query("MATCH (n:Note) WHERE n.uid=\"#{params[:id]}\" RETURN n")["data"][0][0]["data"]
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
