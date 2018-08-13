class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true, counter_cache: true
  belongs_to :comment, counter_cache: true
  has_many   :replies, class_name: 'Reply', foreign_key: 'reply_id', dependent: :destroy
  belongs_to :reply, optional: true

  default_scope { where('deleted_at IS NULL') }
end