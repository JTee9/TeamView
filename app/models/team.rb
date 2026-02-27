class Team < ApplicationRecord
  belongs_to :user

  validates :teamname, presence: true
  validates :division, presence: true
  validates :captain, presence: true
  validates :motto, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
