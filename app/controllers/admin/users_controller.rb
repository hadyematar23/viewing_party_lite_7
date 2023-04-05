class Admin::UsersController < ApplicationController
  def new 
  end

  def dashboard

  end

  def show 
    @x = UsersController.new.set_dashboard(params[:id])
    render template: 'users/dashboard'
  end

  def discover
    @user = current_user
  end


end