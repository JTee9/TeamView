class Team < ApplicationRecord
  belongs_to :user
  has_many :players, dependent: :destroy
  
  validates :teamname, presence: true
  validates :api_football_id, uniqueness: true, allow_nil: true
end
