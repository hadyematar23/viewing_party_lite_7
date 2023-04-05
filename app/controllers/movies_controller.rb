class MoviesController < ApplicationController
  before_action :set_user

  def show 
    @movie = MoviesFacade.new.get_all_movie_info(params[:id])
  end

  def index 
    if params[:search]
      @results = MoviesFacade.new.search_results((params[:search]))
    elsif params[:top_rated]
      @results = MoviesFacade.new.top_rated_movies
    end
  end

  private 

  def set_user 
    @user = current_user
  end
end
