class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :favorites, dependent: :destroy
  
  # Check if user has favorited a team (by api_football_id)
  def favorited?(team)
    favorites.exists?(api_football_id: team.api_football_id, league: team.league)
  end
  
  # Get user's favorite for a specific league
  def favorite_for_league(league)
    favorites.find_by(league: league)
  end
end
