require 'rails_helper'

RSpec.describe "User Discovery Page", type: :feature do
  before :each do 
  @andra = User.create!(name: "Andra", email: "andra@turing.edu", password: "hady", password_confirmation: "hady")
  @hady = User.create!(name: "Hady", email: "hady@turing.edu", password: "hady", password_confirmation: "hady") 

  @halloween = Party.create!(name: "Halloween Party", user_id: @hady.id, movie_id: 1, party_date: "2023/10/31", party_time: "10:30", duration: 123) 
  @girls_night = Party.create!(name: "Girl's Night", user_id: @hady.id, movie_id: 2, party_date: "2023/10/31", party_time: "02:00", duration: 210) 
  @eighties = Party.create!(name: "Eighties Themed", user_id: @hady.id, movie_id: 3, party_date: "2023/10/31", party_time: "02:00", duration: 210) 
  @other = Party.create!(name: "Other", user_id: @hady.id, movie_id: 4, party_date: "2023/10/31", party_time: "02:00", duration: 210) 

  @usp1 = UserParty.create!(user_id: @andra.id, party_id: @halloween.id) 
  @usp2 = UserParty.create!(user_id: @andra.id, party_id: @girls_night.id) 
  @usp3 = UserParty.create!(user_id: @andra.id, party_id: @eighties.id) 
  
  end 

  describe "visit the users/:id/discover path wehre id is the id of a valid user" do 
    it "should see a button to discover top rated movies" do 
      visit "/users/#{@hady.id}/discover"
      expect(page).to have_button("Discover Top Rated Movies")
    end

    it "should have a text field to enter keywords to search by movie title and a button to search by movie title" do 
      visit "/users/#{@hady.id}/discover"
      expect(page).to have_selector("form")
      expect(page).to have_field("search")
    end

    it "click on the top rated movies page button adn you are redirect to the users/:user_id/movies path" do 

      VCR.use_cassette("top_rated_movies") do
      visit "/users/#{@hady.id}/discover"
        click_button("Discover Top Rated Movies")
        expect(current_path).to eq("/users/#{@hady.id}/movies")
      end 
    end

    it "fill in the search box and click search and you are taken to the users/:user_id/movies path" do 
      VCR.use_cassette("search_results_beautiful") do
        visit "/users/#{@hady.id}/discover"
        fill_in "search", with: "Beautiful"
        click_button("Search")

        expect(current_path).to eq("/users/#{@hady.id}/movies")
      end 
    end
  end
end 