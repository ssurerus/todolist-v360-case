class List < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  enum :status, { active: 0, archived: 1 }
  validates :title, presence: true
end
