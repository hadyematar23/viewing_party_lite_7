require "rails_helper"

RSpec.describe User, type: :model do
  let!(:andra) { User.create!(name: "Andra", email: "andra@turing.edu", password: "hady", password_confirmation: "hady") }
  let!(:hady) { User.create!(name: "Hady", email: "hady@turing.edu", password: "hady", password_confirmation: "hady") }

  let!(:halloween) { Party.create!(name: "Halloween Party", user_id: andra.id, party_date: "2023/10/31", party_time: "10:30", duration: 123) }
  let!(:girls_night) { Party.create!(name: "Girl's Night", user_id: hady.id, party_date: "2023/10/31", party_time: "02:00", duration: 210) }
  let!(:eighties) { Party.create!(name: "Eighties Themed", user_id: hady.id, party_date: "2023/10/31", party_time: "02:00", duration: 210) }
  let!(:other) { Party.create!(name: "Other", user_id: hady.id, party_date: "2023/10/31", party_time: "02:00", duration: 210) }

  let!(:usp1) { UserParty.create!(user_id: andra.id, party_id: halloween.id, invite_status: 0) }
  let!(:usp2) { UserParty.create!(user_id: andra.id, party_id: girls_night.id, invite_status: 0) }
  let!(:usp3) { UserParty.create!(user_id: andra.id, party_id: eighties.id, invite_status: 1) }
  let!(:usp4) { UserParty.create!(user_id: hady.id, party_id: eighties.id, invite_status: 2) }


  describe "relationships" do
    it { should have_many :user_parties }
    it { should have_many(:parties).through(:user_parties) }
  end

  describe "validations" do 
    it { should validate_uniqueness_of(:email)}
    it { should validate_presence_of(:password_digest)}
    it { should have_secure_password}

  end

  describe "instance methods" do

    it "get_host_parties" do
      expect(hady.get_host_parties).to eq([girls_night, eighties, other])
      expect(hady.get_host_parties).to_not eq([halloween])
    end

    it "invited_parties" do 
      expect(andra.invited_parties).to eq([halloween, girls_night])
      expect(hady.get_host_parties).to_not eq([eighties])
    end 
  end

  describe "class methods" do 

    it "can find the host" do 
      expect(User.find_host(andra.id)).to eq(andra.name)
    end
  end
end