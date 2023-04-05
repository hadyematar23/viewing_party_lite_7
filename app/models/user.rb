class User < ApplicationRecord
  has_many :user_parties
  has_many :parties, through: :user_parties
  enum role: {visitor: 0, registered_user: 1, admin: 2}

  def get_host_parties
    Party.where(user_id: self.id)
  end

  def invited_parties
    Party.joins(:user_parties).where(user_parties: { user_id: self.id }).where(user_parties: {invite_status: "invited"})
  end

  def self.find_host(user_id)
    find(user_id).name
  end

  validates :email, uniqueness: true, presence: true
  validates :name, presence: true
  validates_presence_of :password_digest 
  has_secure_password
end