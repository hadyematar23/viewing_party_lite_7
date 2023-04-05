require 'rails_helper'

RSpec.describe 'landing page, index', type: :feature do
  describe "as a user" do
    before :each do
      @user1 = User.create!(name: "Andra", email: "andra@turing.edu", password: "andrapassword", password_confirmation: "andrapassword", role: 2)
      @user2 = User.create!(name: "Hady", email: "hady@turing.edu", password: "hadypassword", password_confirmation: "hadypassword", role: 1)
      @visitor = User.create!(name: "Visitor", email: "visitor@turing.edu", password: "visitorpassword", password_confirmation: "visitorpassword")
    end

    describe "when visits landing page ('/'')" do
      it "the user will see the title of the application" do 
        visit landing_path
        expect(page).to have_content("Viewing Party Application (Andra and Hady)")
      end 

      it "user will see a button to create a new user" do 
        visit landing_path
        expect(page).to have_button("Create New User")
        click_button("Create New User")
        expect(current_path).to eq("/register")
      end 

      # it "will see list of existing users with links to their respective dashboards" do 
      #   visit landing_path
      #   expect(page).to have_content("#{@user1.name}")
      #   expect(page).to have_link("#{@user1.name}'s Dashboard")
      # end 

      # it "if you click on a user's dashboard link, you will be taken to that user's dashboard" do
      #   visit landing_path
      #   within("#existing_users") do 
      #     click_link("#{@user1.name}'s Dashboard")
      #     expect(current_path).to eq("/users/#{@user1.id}")
      #   end
      # end

      it "link to go back to landing page" do 
        visit landing_path
        expect(page).to have_link("Back to Landing Page")
        click_link("Back to Landing Page")
        expect(current_path).to eq("/")
      end 
    end 
  end 

  describe "behavioral differences based on logged in status" do 
    before :each do
      @user1 = User.create!(name: "Andra", email: "andra@turing.edu", password: "andrapassword", password_confirmation: "andrapassword", role: 2)
      @user2 = User.create!(name: "Hady", email: "hady@turing.edu", password: "hadypassword", password_confirmation: "hadypassword", role: 1)
      @visitor = User.create!(name: "Visitor", email: "visitor@turing.edu", password: "visitorpassword", password_confirmation: "visitorpassword")
    end

    it "when i visit the landing page as a visitor, do not see a list of existing users" do 
      visit landing_path
      expect(page).to_not have_css('div#existing_users')
    end

    it "when i visit the page as a logged in user, i would see the list of existing users email addresses" do 
      visit login_path
      fill_in :user_name, with: "hady@turing.edu"
      fill_in :user_password, with: "hadypassword"
      click_on "Log In"

      visit landing_path
      expect(page).to have_css('div#email_addresses')
      expect(page).to have_content("hady@turing.edu")
      expect(page).to have_content("andra@turing.edu")
      expect(page).to_not have_content("visitor@turing.edu")  
    end

    it "a visitor cannot visit the dashboard unless they are logged in or registered to access the dashboard" do 
      visit landing_path
      visit "/dashboard"
      
      expect(current_path).to eq("/")
      expect(page).to have_content("You must be logged in or registered to access the dashboard")
    end
  end 
end