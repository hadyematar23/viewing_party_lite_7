require 'rails_helper'

RSpec.describe 'create/register new user, create page', type: :feature do
  describe "as a user" do
    describe "when user attempts to register a new user ('/register')" do

      before :each do 
        @user1 = User.create!(name: "Andra", email: "andra@turing.edu", password: "hadypassword", password_confirmation: "hadypassword")
        @user2 = User.create!(name: "Hady", email: "hady@turing.edu", password: "hadypassword", password_confirmation: "hadypassword")
      end 

      it "when the user inputs a unique email into the form on the registrations new page and clicks submit, a new user is created with that email and the user is redirected to the new user's dashboard page" do 
        visit "/register"
        fill_in :user_name, with: "Malena"
        fill_in :user_email, with: "malena@gmail.com"
        fill_in :user_password, with: "test"
        fill_in :user_password_confirmation, with: "test"

        click_button("Register User")
        expect(User.last.name).to eq("Malena")
        expect(User.last.email).to eq("malena@gmail.com")
        expect(current_path).to eq("/users/#{User.last.id}")

       end 

       it "there is also a registration button" do 

          visit "/register"
          expect(page).to have_button("Register User")
       end
      

      describe "password and user authentication" do 
        it "there is a location to fill out your name, email, password, password confirmation" do 
           visit "/register"

           expect(page).to have_selector('form')
           expect(page).to have_field(:user_name)
           expect(page).to have_field(:user_email)
           expect(page).to have_field(:user_password)
           expect(page).to have_field(:user_password_confirmation)

        end

        describe "if i fail to fill in name, unique email or matching passwords, takes me back to the /register page" do 
          it "different passwords" do 
            visit "/register"
            fill_in :user_name, with: "Hady"
            fill_in :user_email, with: "hadafay@turing.edu"
            fill_in :user_password, with: "test"
            fill_in :user_password_confirmation, with: "tesat"
            click_button("Register User")
            expect(current_path).to eq("/register")
            expect(page).to have_content("Password confirmation doesn't match Password")
          end

          it "email is not unique" do 
            visit "/register"
            fill_in :user_name, with: "Hady"
            fill_in :user_email, with: "hady@turing.edu"
            fill_in :user_password, with: "test"
            fill_in :user_password_confirmation, with: "test"
            click_button("Register User")
            expect(current_path).to eq("/register")
            expect(page).to have_content("Email has already been taken")
          end

          it "name is not present" do 
            visit "/register"
            fill_in :user_email, with: "hadafafy@turing.edu"
            fill_in :user_password, with: "test"
            fill_in :user_password_confirmation, with: "test"
            click_button("Register User")
            expect(current_path).to eq("/register")
            expect(page).to have_content("Name can't be blank")
          end
        end 
      end 
    end
  end 
end 