class Item < ApplicationRecord
  belongs_to :list
  enum :status, { backlog: 0, in_progress: 1, done: 2 }
  validates :title, presence: true
  scope :ordered, -> { order(due_at: :asc) }
end
