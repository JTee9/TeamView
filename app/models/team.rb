class Team < ApplicationRecord
  belongs_to :user
  has_many :players, dependent: :destroy
  
  validates :teamname, presence: true
  validates :api_football_id, uniqueness: true, allow_nil: true
  
  # Count how many fans this team has (by api_football_id)
  def fan_count
    Favorite.where(api_football_id: api_football_id, league: league).count
  end
  
  # Get all fans for this team
  def fans
    user_ids = Favorite.where(api_football_id: api_football_id, league: league).pluck(:user_id)
    User.where(id: user_ids)
  end
end
