class SessionsController < ApplicationController
  def destroy 
    session.delete(:user_id)
    redirect_to "/"
  end

  def create
    begin
    user = User.find_by(email: params[:user_name])
      if user.authenticate(params[:user_password])
        session[:user_id] = user.id
        if user.role == "registered_user"
          redirect_to user_dashboard_path
        elsif user.role == "admin"
          redirect_to "/admin/dashboard"
        end 
      else 
        flash[:error] = "Incorrect password"
        redirect_to login_path
      end
    rescue => error
      flash[:error] = "Username is not found"
      redirect_to login_path
    end 
  end
end
