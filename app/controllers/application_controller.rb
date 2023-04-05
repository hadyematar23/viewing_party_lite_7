class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :current_user_visitor
  helper_method :current_user_registered

  def current_user_visitor
    if session[:user_id] == nil 
      true
    else 
      false
    end
  end

  def current_user_registered
    if current_user && current_user.role == "registered_user"
      true
    else 
      false
    end
  end

  def current_user 
    current_user = User.find(session[:user_id]) if session[:user_id]
  end
end
