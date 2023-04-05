class PartiesController < ApplicationController
  def new 
    if current_user 
      @movie = MoviesFacade.new.get_all_movie_info(params[:movie_id])
      @user = current_user
      @all_users = User.all
    else 
      flash[:error] = "Must be logged in to register a viewing party"
      redirect_to "/movies/#{params[:movie_id]}"
    end 

  end

  def create
    @movie = MoviesFacade.new.get_all_movie_info(params[:movie_id])
    @party = Party.new(party_params)
    @party.user_id = current_user.id
    
    if @party.duration >= @movie.raw_runtime
      @party.save
      if params[:invites].present?
        params[:invites].each do |user_id|
          UserParty.create!(party_id: Party.all.last.id, user_id: user_id)
        end
      end
      flash[:notice] = "Party successfully created"
      redirect_to "/dashboard"
    else
      flash[:notice] = "Duration is less than actual play time"
      redirect_to "/movies/#{@movie.movie_id}/parties/new"
    end
  end

  private

  def party_params
    params.permit(:name, :party_date, :party_time, :user_id, :duration, :movie_id)
  end
end
