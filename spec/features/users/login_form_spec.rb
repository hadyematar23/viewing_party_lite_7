require 'rails_helper'

RSpec.describe "User Login Page", type: :feature do
  before :each do 
  @andra = User.create!(name: "Andra", email: "andra@turing.edu", password: "hady", password_confirmation: "hady")
  @hady = User.create!(name: "Hady", email: "hady@turing.edu", password: "hady", password_confirmation: "hady", role: 1)
  end 

  describe "login page" do 
    it "visiting the landing page you can login if you provide the correct email and password" do 
      visit "/"

      expect(page).to have_link("Login", href: login_path)
      click_link("Login")
      
      expect(current_path).to eq(login_path)
      expect(page).to have_field(:user_name)
      expect(page).to have_field(:user_password)
      
      fill_in :user_name, with: "hady@turing.edu"
      fill_in :user_password, with: "hady"

      click_on "Log In"

      expect(current_path).to eq(user_dashboard_path)

    end

    it "sad path for not providing the correct email - password combo: incorrect password" do 
      visit "/"

      expect(page).to have_link("Login", href: login_path)
      click_link("Login")
      
      expect(current_path).to eq(login_path)
      expect(page).to have_field(:user_name)
      expect(page).to have_field(:user_password)
      
      fill_in :user_name, with: "hady@turing.edu"
      fill_in :user_password, with: "hadya"

      click_on "Log In"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Incorrect password")
    end

    it "sad path for not providing the correct email - password combo: incorrect username" do 
      visit "/"

      expect(page).to have_link("Login", href: login_path)
      click_link("Login")
      
      expect(current_path).to eq(login_path)
      expect(page).to have_field(:user_name)
      expect(page).to have_field(:user_password)
      
      fill_in :user_name, with: "haady@turing.edu"
      fill_in :user_password, with: "hady"

      click_on "Log In"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Username is not found")
    end

    describe "session ID Feature tests- logging in and logging out" do 
      it "after logging in, the session id will be saved as that user id" do 
        visit login_path

        fill_in :user_name, with: "hady@turing.edu"
        fill_in :user_password, with: "hady"
        click_on "Log In"
        visit "/"
        expect(page).to have_content("Log Out")
        expect(page).to_not have_content("Create New User")
      end

      it "sad path- failed login after logging in, the session id will be saved as that user id" do 
        visit login_path

        fill_in :user_name, with: "haady@turing.edu"
        fill_in :user_password, with: "hady"
        click_on "Log In"
        visit "/"
        expect(page).to_not have_content("Log Out")
        expect(page).to have_content("Create New User")
      end

      it "when i see the link to log out, i click it and am taken to the landing page again and the log out link is turned back into a login link" do 
        visit login_path

        fill_in :user_name, with: "hady@turing.edu"
        fill_in :user_password, with: "hady"
        click_on "Log In"
        visit "/"
        expect(page).to have_content("Log Out")
        expect(page).to_not have_content("Create New User")
        click_on "Log Out"
        expect(current_path).to eq("/")
        expect(page).to_not have_content("Log Out")
        expect(page).to have_content("Create New User")
        expect(page).to have_content("Login")

      end
    end 
  end
end 
