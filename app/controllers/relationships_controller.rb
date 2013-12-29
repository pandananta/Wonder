class RelationshipsController < ApplicationController

  def create
    @rel = Relationship.new
    @rel.uid1 = params["uid1"] 
    @rel.uid2 = params["uid2"] 
    
    respond_to do |format|
      if @rel.save
        format.html { redirect_to("/notes/#{@rel.uid1}")}
      else
        format.html { redirect_to "/"}
      end
    end
  end

end
