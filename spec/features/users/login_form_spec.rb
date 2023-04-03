require 'rails_helper'

RSpec.describe "User Login Page", type: :feature do
  before :each do 
  @andra = User.create!(name: "Andra", email: "andra@turing.edu", password: "hady", password_confirmation: "hady")
  @hady = User.create!(name: "Hady", email: "hady@turing.edu", password: "hady", password_confirmation: "hady")
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

      expect(current_path).to eq(user_dashboard_path(User.last))

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
  end
end 
