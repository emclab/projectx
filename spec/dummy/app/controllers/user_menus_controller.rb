class UserMenusController < ApplicationController
  before_filter :require_signin

  def index  
    #set session vars for viewing history
    session[:page_step] = 1
    session[:page1] = user_menus_path
    render 'user_menus/index'
  end 
end
