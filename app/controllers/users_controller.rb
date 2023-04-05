class UsersController < ApplicationController
  def new 
  end

  def set_dashboard(user_id)
    require 'pry'; binding.pry
    @user = User.find(user_id)
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

  def dashboard
    if current_user
       set_dashboard(current_user.id)
    else
      flash[:error] = "You must be logged in or registered to access the dashboard"
      redirect_to "/"
    end
  end

  def new 
    @user = User.new
  end

  def show 
    @user = User.find(params[:id])
  end

  def create 
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to "/dashboard"
    else 
      flash[:error] = user.errors.full_messages
      redirect_to "/register"
    end
  end 

  def login_form

  end

  def discover
    @user = current_user
  end

  private 

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end