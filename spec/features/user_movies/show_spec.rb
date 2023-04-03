require 'rails_helper'

RSpec.describe "User_movie Index Page", type: :feature do
  before :each do 
    @andra = User.create!(name: "Andra", email: "andra@turing.edu", password: "hady", password_confirmation: "hady")
    @hady = User.create!(name: "Hady", email: "hady@turing.edu", password: "hady", password_confirmation: "hady")
    VCR.use_cassette("top_rated_movies") do
      @results = MoviesFacade.new.top_rated_movies
    end
  end 
  describe "when visit a movie's detail page" do 

    it "should show a button to create a viewing party" do
      VCR.use_cassette("movie_id_238_usermovie_show_spec") do
        visit "/users/#{@hady.id}/movies/#{@results[0].movie_id}"
   
      expect(page).to have_link("Return to Discover Page", href: "/users/#{@hady.id}/discover")

      expect(page).to have_link("Create Viewing Party", href: "/users/#{@hady.id}/movies/#{@results[0].movie_id}/parties/new")
      end 
    end 

    
  end 
end 
