class UsersController < ApplicationController
  def new 
  end

  def dashboard
    @user = User.find(params[:id])
    @invited_parties = @user.invited_parties
    @all_user_parties_host = @user.get_host_parties.map do |party|
      movie_info = MoviesFacade.new.get_all_movie_info(party.movie_id)

      { party: party, 
        host: User.find_host(party.user_id), 
        movie_title: movie_info.name, 
        movie_image: "https://image.tmdb.org/t/p/w500".concat(movie_info.image),
        list_invitees: party.list_invitees }
    end

    @invited_parties_with_hosts = @invited_parties.map do |party|
      movie_info = MoviesFacade.new.get_all_movie_info(party.movie_id)

      { party: party, 
        host: User.find_host(party.user_id), 
        movie_title: movie_info.name, 
        movie_image: "https://image.tmdb.org/t/p/w500".concat(movie_info.image),
        list_invitees: party.list_invitees }
    end
  end

  def new 
    @user = User.new
  end

  def create 
    user = User.new(user_params)

    if user.save
      redirect_to "/users/#{user.id}"
    else 
      flash[:error] = user.errors.full_messages
      redirect_to "/register"
    end
  end 

  def login_form
  end

  def login_user
    begin
    user = User.find_by(email: params[:user_name])
      if user.authenticate(params[:user_password])
        redirect_to user_dashboard_path(user)
      else 
        require 'pry'; binding.pry
        flash[:error] = "Incorrect password"
        redirect_to login_path
      end
    rescue => error
      flash[:error] = "Username is not found"
      redirect_to login_path
    end 
  end

  def discover
    @user = User.find(params[:id])
  end

  private 

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end