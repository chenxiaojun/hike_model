class ActivityJoin < ApplicationRecord
  belongs_to :activity
  scope :passed, -> { where(join_status: 'passed') }
end