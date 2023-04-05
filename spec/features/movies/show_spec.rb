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
        visit "/movies/#{@results[0].movie_id}"
   
      expect(page).to have_link("Return to Discover Page", href: "/dashboard/discover")

      expect(page).to have_link("Create Viewing Party", href: "/movies/#{@results[0].movie_id}/parties/new")
      end 
    end 
  end 

  describe "not logged in and trying to create a party" do 

    it "if go to a movies show page as a visitor and try to click a button to create a view/1ing party will be redirected to the movies show page and a message saying that you must be logged in or registered" do 
      VCR.use_cassette("movie_id_238_usermovie_logged_in_show_spec", :allow_playback_repeats => true) do
      visit "/movies/134"
      click_on("Create Viewing Party")
      expect(current_path).to eq("/movies/134")
      expect(page).to have_content("Must be logged in to register a viewing party")
      end 
    end

    it "if you are registered and want to create a viewing party, you can do so" do 
      VCR.use_cassette("movie_id_238_usermovie_logged_in_show2_spec", :allow_playback_repeats => true) do
      visit login_path

      fill_in :user_name, with: "hady@turing.edu"
      fill_in :user_password, with: "hady"
      click_on "Log In"

      visit "/movies/134"
      click_on("Create Viewing Party")
      expect(current_path).to eq("/movies/134/parties/new")
      end 
    end
  end
end 
