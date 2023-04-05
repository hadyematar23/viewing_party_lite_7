require 'rails_helper'

RSpec.describe "User Show Page", type: :feature do
  before :each do 
    VCR.use_cassette("top_rated_movies_dashboard") do
      @results = MoviesFacade.new.top_rated_movies

      @andra = User.create!(name: "Andra", email: "andra@turing.edu", password: "hady", password_confirmation: "hady") 
      @hady = User.create!(name: "Hady", email: "hady@turing.edu", password: "hady", password_confirmation: "hady") 
      @mike = User.create!(name: "Mike", email: "mky@turing.edu", password: "hady", password_confirmation: "hady") 
      @malena = User.create!(name: "Malena", email: "malena@tours.edu", password: "hady", password_confirmation: "hady", role: 1)
      @jack = User.create!(name: "Jack", email: "jack@gmail.edu", password: "hady", password_confirmation: "hady", role: 2) 


      @halloween = Party.create!(name: "Halloween Party", user_id: @hady.id, movie_id: @results[2].movie_id, party_date: "2023/10/31", party_time: "10:30", duration: 123) 

      @girls_night= Party.create!(name: "Girl's Night", user_id: @hady.id, movie_id: @results[3].movie_id, party_date: "2023/01/02", party_time: "02:00", duration: 210) 

      @eighties = Party.create!(name: "Eighties Themed", user_id: @hady.id, movie_id: @results[4].movie_id, party_date: "2023/05/01", party_time: "02:00", duration: 210) 
      
      @other = Party.create!(name: "Other", user_id: @hady.id, party_date: "01/01/2023", movie_id: @results[0].movie_id, party_time: "02:00", duration: 210) 

      @up1 = UserParty.create!(user_id: @andra.id, party_id: @halloween.id, invite_status: 0)
      @up2 = UserParty.create!(user_id: @andra.id, party_id: @girls_night.id, invite_status: 0)
      @up5 = UserParty.create!(user_id: @mike.id, party_id: @halloween.id, invite_status: 0)
      @up3 = UserParty.create!(user_id: @andra.id, party_id: @eighties.id, invite_status: 1) 
      @up4 = UserParty.create!(user_id: @hady.id, party_id: @eighties.id, invite_status: 2) 
    end 
  end 

  describe "When I visit '/users/:id'" do
    it "I see user's name at the top of the page" do
      VCR.use_cassette("top_rated_dashboard_1") do
        visit login_path
        fill_in :user_name, with: "andra@turing.edu"
        fill_in :user_password, with: "hady"
  
        click_on "Log In"
        visit "/dashboard"
        expect(page).to have_content("Andra's Dashboard")
      end
    end

    it "I see a button to Discover Movies that directs to a discover page" do
      VCR.use_cassette("top_rated_dashboard_2") do
        visit login_path
        fill_in :user_name, with: "andra@turing.edu"
        fill_in :user_password, with: "hady"
  
        click_on "Log In"
        visit "/dashboard"
        expect(page).to have_button("Discover Movies")
        click_button("Discover Movies")

        expect(current_path).to eq("/dashboard/discover")
      end
    end

    it "I see a section that lists viewing parties they've been invited to" do
      VCR.use_cassette("top_rated_dashboard_3") do
        visit login_path
        fill_in :user_name, with: "andra@turing.edu"
        fill_in :user_password, with: "hady"
  
        click_on "Log In"
        visit "/dashboard"
        within "#viewing_parties_invited" do
          expect(page).to have_content("Andra's Viewing Parties to Which She Has Been Invited")
          expect(page).to have_content(@halloween.name)
          expect(page).to have_content(@girls_night.name)
          expect(page).to_not have_content(@eighties.name)
          expect(page).to_not have_content(@other.name)
        end
      end
    end

    describe "The person who created the viewing party sees it listed under their hosted parties but the person who did not create it does not see it under their hosted parties" do
      before :each do 

        VCR.use_cassette("dashboard_before_do777", :allow_playback_repeats => true) do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@hady)
            @results = MoviesFacade.new.top_rated_movies

          visit "/movies/#{@results[0].movie_id}/parties/new"
            within("div#viewing_party_form") do 
              fill_in :name, with: "Fun Party"
              fill_in :duration, with: 180
              fill_in :party_date, with: "2023/01/01"
              fill_in :party_time, with: "10:00"
              
              within("div##{@mike.name}") do
                check("invites[]", option: @mike.id)
              end

            click_button "Create Party"
          end
        end 
      end 

      it "directs to the dashboard of the creator who has the party listed under their hosted parties but not invited parties" do 
          expect(current_path).to eq("/dashboard")
          within("div#host_parties") do
            within("div##{Party.last.id}") do
              expect(page).to have_content("Fun Party")
            end
          end

          within("div#viewing_parties_invited") do
            expect(page).to_not have_content("Fun Party")
          end 
      end 
    
      it "when visiting an invitee, it shows under their invited parties but not hosted parties" do
        VCR.use_cassette("dashboard_before_do_2", :allow_playback_repeats => true) do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@mike)

          visit "/dashboard" 
          within("div#host_parties") do
            expect(page).to_not have_content("Fun Party")
          end 

          within("div#viewing_parties_invited") do
            expect(page).to have_content("Fun Party")
          end 
        end
      end 

      it "when visiting an invitee that did not accept or create it, does not show up in either" do 
        VCR.use_cassette("dashboard_before_do_3", :allow_playback_repeats => true) do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@andra)
          visit "/dashboard" 

          within("div#host_parties") do
            expect(page).to_not have_content("Fun Party")
          end 

          within("div#viewing_parties_invited") do
            expect(page).to_not have_content("Fun Party")
          end 
        end
      end
    end

    it "when visiting a user dashboard will see the parties that the person has been invited to" do 
      VCR.use_cassette("dashboard_spec_6") do
        visit login_path
        fill_in :user_name, with: "andra@turing.edu"
        fill_in :user_password, with: "hady"
  
        click_on "Log In"
        visit "/dashboard"

        within("div#viewing_parties_invited") do
          expect(page).to have_content(@halloween.name)
          expect(page).to_not have_content(@eighties.name)
        end 
      end
    end

    it "will see the movie title of the movie to which they have been invited" do 

      VCR.use_cassette("dashboard_spec_movie_test") do
        visit login_path
        fill_in :user_name, with: "andra@turing.edu"
        fill_in :user_password, with: "hady"
  
        click_on "Log In"
        visit "/dashboard"
      
      within("div#viewing_parties_invited") do
        within("div##{@halloween.id}") do 
          expect(page).to have_content(@halloween.party_date.strftime('%m/%d/%Y'))
          expect(page).to have_content(@halloween.party_time.strftime("%I:%M %p"))
          expect(page).to have_content("Host: #{@hady.name}")
          expect(page).to have_css("img[src*='#{@results[2].image}']")
          within("div#title") do
            expect(page).to have_content(/.*/)
            expect(page).to have_link(href: "/users/#{@hady.id}/movies/#{@results[2].movie_id}")
          end
          within("div#list_of_invitees") do 
            expect(page).to have_content(@mike.name)
            expect(page).to have_css('b', text: @andra.name)
            expect(page).to_not have_content(@malena.name)
          end
        end
      end
    end
  end

  it "will see viewing parties user created with details" do
    VCR.use_cassette("dashboard_spec_movie_party_test") do
      visit login_path
      fill_in :user_name, with: "hady@turing.edu"
      fill_in :user_password, with: "hady"

      click_on "Log In"
      visit "/dashboard"

      within("div#host_parties") do
        within("div##{@halloween.id}") do 
          expect(page).to have_content("Host: #{@hady.name}")
          expect(page).to have_content(@halloween.party_date.strftime('%m/%d/%Y'))
          expect(page).to have_content(@halloween.party_time.strftime("%I:%M %p"))
          expect(page).to have_css("img[src*='#{@results[2].image}']")
          within("div#title") do
            expect(page).to have_content(/.*/)
            expect(page).to have_link(href: "/users/#{@hady.id}/movies/#{@results[2].movie_id}")
          end
          within("div#list_of_invitees") do 
            expect(page).to have_content(@mike.name)
            expect(page).to have_content(@andra.name)
            expect(page).to_not have_content(@malena.name)
          end
        end
      end
    end
  end

  
  end
end