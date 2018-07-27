class ActivityJoin < ApplicationRecord
  belongs_to :activity
  belongs_to :user
  scope :passed, -> { where(join_status: 'passed') }
end