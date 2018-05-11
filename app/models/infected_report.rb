class InfectedReport < ApplicationRecord
  belongs_to :survivor

  validates :survivor_id, :reporter_id, presence: true
  validates :survivor_id, uniqueness: { scope: :reporter_id }
end
