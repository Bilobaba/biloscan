class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :trackable, :validatable
  devise :database_authenticatable, :recoverable, :registerable, :rememberable
end
