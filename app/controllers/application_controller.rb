class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :connect_to_neo

  def connect_to_neo
  	@@neo ||= Neography::Rest.new
  end
end
