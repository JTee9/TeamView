class Favorite < ApplicationRecord
  belongs_to :user
  
  validates :user_id, uniqueness: { scope: :league, message: "can only favorite one team per league" }
  validates :league, presence: true
  validates :api_football_id, presence: true
  
  # Helper method to get the team (returns nil if not found)
  def team
    @team ||= Team.find_by(api_football_id: api_football_id, league: league)
  end
  
  # Check if the team still exists
  def team_exists?
    team.present?
  end
end