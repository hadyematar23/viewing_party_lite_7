require 'rails_helper'

RSpec.describe "party new page", type: :feature do
  before :each do 
    @andra = User.create!(name: "Andra", email: "andra@turing.edu", password: "andrapassword", password_confirmation: "andrapassword")
    @hady = User.create!(name: "Hady", email: "hady@turing.edu", password: "hadypassword", password_confirmation: "hadypassword", role: 2)
    @mike = User.create!(name: "Mike", email: "mike@turing.edu", password: "mikepassword", password_confirmation: "mikepassword" )

    @halloween = Party.create!(name: "Halloween Party", user_id: @andra.id, movie_id: 1, party_date: "2023/01/01", party_time: "10:30", duration: 123)
    @girls = Party.create!(name: "Girls Night", user_id: @hady.id, movie_id: 2, party_date: "2023/01/01", party_time: "10:30", duration: 123)
    @eighties = Party.create!(name: "Eighties", user_id: @hady.id, movie_id: 3, party_date: "2023/01/01", party_time: "10:30", duration: 123)
    
    visit login_path
    fill_in :user_name, with: "hady@turing.edu"
    fill_in :user_password, with: "hadypassword"

    click_on "Log In"

    VCR.use_cassette("top_rated_movies") do
      @results = MoviesFacade.new.top_rated_movies
    end
  end 

  describe "when visit the viewing party page", :vcr do 
    it "when you enter the viewing party, it lists the movie title, the voting average and the runtime in hours and minutes" do
      visit "/movies/#{@results[0].movie_id}"

      click_link("Create Viewing Party")
        within("div#movie_title") do 
          expect(page).to have_content(/Movie Title(?=.+)/)
        end

        within("div#vote_average") do 
          expect(page).to have_content(/\d+\.\d+/)
        end
      
        within("div#runtime") do 
          expect(page).to have_content("Runtime")
          expect(page).to have_content("hours")
          expect(page).to have_content("minutes")
        end
      end 

    it "when you enter the genres, the summary description, and the first 10 cast members and their characters" do
      visit "/movies/#{@results[0].movie_id}"

      click_link("Create Viewing Party")
      within("div#genres") do 
        expect(page).to have_content(/Genres(?=.+)/)
      end

      within("div#description") do 
        expect(page).to have_content(/Summary Description(?=.+)/)
      end

      within("div#cast_members") do 
        expect(all('li').count).to eq(10)
        all('li').each do |li|
          expect(li.text).to include("as")
        end
      end
    end 


    it "when you enter, you see the count of reviews, and the information about each author" do
      visit "/movies/#{@results[0].movie_id}"

      click_link("Create Viewing Party")
      within("div#count_of_reviews") do 
        expect(page).to have_content("Number of Reviews")
        expect(page).to have_content(/\d+/)
      end

      within("div#author_information") do 
        expect(page).to have_content("Username")
        expect(page).to have_content("Avatar path")
        expect(page).to have_content("Rating")
      end
    end 
   

    it "when you enter /users/:user_id/movies/:movid_id/parties/new you will see a form below the name with information to fill out including duration of party, date, time, and submit button" do 
        visit "/movies/#{@results[0].movie_id}/parties/new"
 
        within("div#viewing_party_form") do 
          expect(page).to have_selector("form")
          expect(page).to have_field("duration", type: 'number')
          expect(page).to have_field("party_date", type: 'date')
          expect(page).to have_field("party_time")
          expect(page).to have_button("Create Party")
        end 
      end


    it "when you enter /users/:user_id/movies/:movid_id/parties/new you will see a form below the name that includes all the current users registered in the system and a checkbox next to their name to invite them to the viewing party" do 
        visit "/movies/#{@results[0].movie_id}/parties/new"
        within("div#viewing_party_form") do 
          within("div#Hady") do 
            expect(page).to have_content("Check to invite to viewing party Hady")
            expect(page).to have_selector("input[type='checkbox']")
          end

          within("div#Andra") do 
            expect(page).to have_content("Check to invite to viewing party Andra")
            expect(page).to have_selector("input[type='checkbox']")
          end
        end 
      end
    end 

    describe "when you fill in the form on the viewing party new page and click create", :vcr do
      it "if you fill in valid info, you successfully create a new party and are redirected to the user's dashboard" do 
        visit login_path
        fill_in :user_name, with: "hady@turing.edu"
        fill_in :user_password, with: "hadypassword"
    
        click_on "Log In"

        visit "/movies/#{@results[0].movie_id}/parties/new"
        
        expect(Party.count).to eq(3)

        within("div#viewing_party_form") do 
          fill_in :name, with: "Fun Party"
          fill_in :duration, with: 180
          fill_in :party_date, with: "2023/01/01"
          fill_in :party_time, with: "10:00"

          within("div##{@hady.name}") do
            check("invites[]", option: @hady.id)
          end
          
          within("div##{@mike.name}") do
            check("invites[]", option: @mike.id)
          end

          click_button "Create Party"
          
          expect(Party.count).to eq(4)
          expect(current_path).to eq("/dashboard")
        end
      end 

      it "if you fill in invalid info, you're unsuccessful and dashboard is refreshed with error msg" do 
        visit "/movies/#{@results[0].movie_id}/parties/new"

        within("div#viewing_party_form") do 
          fill_in :name, with: "Fun Party"
          fill_in :duration, with: 1
          fill_in :party_date, with: "2023/01/01"
          fill_in :party_time, with: "10:00"
          
          within("div##{@hady.name}") do
            check("invites[]", option: @hady.id)
          end
          
          within("div##{@mike.name}") do
            check("invites[]", option: @mike.id)
          end
          
          click_button "Create Party"
        end
        expect(current_path).to eq("/movies/#{@results[0].movie_id}/parties/new")
        expect(page).to have_content("Duration is less than actual play time")
      end 
    end 
  end 

 

