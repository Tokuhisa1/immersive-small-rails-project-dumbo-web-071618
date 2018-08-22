class Trivium < ApplicationRecord
  belongs_to :category
  has_many :trivia_users
  has_many :users, through: :trivia_users
  has_many :answers

end
