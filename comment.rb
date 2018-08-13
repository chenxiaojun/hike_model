class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true, counter_cache: true
  has_many   :replies, dependent: :destroy

  default_scope { where('deleted_at IS NULL') }
end
