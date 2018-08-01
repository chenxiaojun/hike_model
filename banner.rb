class Banner < ApplicationRecord
  validates :target_type, presence: true
  validates :target_id, presence: true
  scope :position_desc, -> { order(position: :desc) }
  belongs_to :target, polymorphic: true, optional: true
end
