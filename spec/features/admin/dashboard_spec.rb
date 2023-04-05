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

  describe "as an admin" do 
    it "when login as admin, I'm taken to admin dashboard " do 
      visit login_path
      fill_in :user_name, with: "jack@gmail.edu"
      fill_in :user_password, with: "hady"

      click_on "Log In"
      
      expect(current_path).to eq("/admin/dashboard")
      expect(page).to have_content("Admin Dashboard")
      within("div#email_addresses") do 
        expect(page).to have_content("malena@tours.edu")
        expect(page).to have_link("malena@tours.edu", href: "/admin/users/#{@malena.id}")
        click_on "malena@tours.edu"
      end

      save_and_open_page

      expect(current_path).to eq("/admin/users/#{@malena.id}")
      expect(page).to have_content("Malena's Dashboard")


    end 
  end
   
end 