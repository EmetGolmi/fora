class User < ApplicationRecord
  has_secure_password
  has_one :civic_profile, dependent: :destroy

  validates :email,  presence: true, uniqueness: true
  validates :handle, presence: true, uniqueness: true
end
