class Activity < ApplicationRecord
  belongs_to :user
  scope :user_visible, -> { where(auth_status: 'passed') }
end
