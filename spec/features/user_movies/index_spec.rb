require 'rails_helper'

RSpec.describe "User_movie Index Page", type: :feature do
  before :each do 
    @andra = User.create!(name: "Andra", email: "andra@turing.edu", password: "hady", password_confirmation: "hady")
    @hady = User.create!(name: "Hady", email: "hady@turing.edu", password: "hady", password_confirmation: "hady") 
  end 
  describe "/users/:user_id/discover page and then click button" do 

    it "when click on top rated movies, you will see the title of the movie as a link and the vote average" do 
      VCR.use_cassette("top_rated_movies") do
        visit "/users/#{@hady.id}/discover"
          click_button("Discover Top Rated Movies")
          expect(page).to have_css(".movie")

          within(first(".movie")) do 
            expect(page).to have_css(".name")
            expect(page).to have_css(".vote_average")

            name_element = find(".name")
            vote_average_element = find(".vote_average")
      
            expect(name_element.text).to be_a(String)
            expect(vote_average_element.text.to_f).to be_a(Float)

            within(".name") do 
              expect(page).to have_link(href: %r{/users/\d+/movies/\d+})
            end
          end
        end 
      end

    it "after searching for a movie and being taken to the movie results page, will see the title to the movie and the vote average of the movie" do 

      VCR.use_cassette("search_results_bad") do

      visit "/users/#{@hady.id}/discover"
      fill_in "search", with: "Bad"
      click_button("Search")

      expect(page).to have_css(".movie")

      within(first(".movie")) do 
        expect(page).to have_css(".name")
        expect(page).to have_css(".vote_average")

        name_element = find(".name")
        vote_average_element = find(".vote_average")
  
        expect(name_element.text).to be_a(String)
        expect(vote_average_element.text.to_f).to be_a(Float)

        within(".name") do 
          expect(page).to have_link(href: %r{/users/\d+/movies/\d+})
        end
      end
    end 
  end

  it "there is also a button to return to the discovery page" do 
    visit "/users/#{@hady.id}/movies"
    
    expect(page).to have_link("Return to Discover Page", href: "/users/#{@hady.id}/discover") 
  end
end 
end 