class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator
  include UserCreator
  mount_uploader :avatar, ImageUploader

  has_many :topics, dependent: :destroy

  # 刷新访问时间
  def touch_visit!
    self.last_visit = Time.zone.now
    save
  end

  def avatar_path
    avatar.url.presence || wx_avatar
  end

  def silenced!(reason, till)
    update(silenced: true,
           silence_at: Time.zone.now,
           silence_reason: reason,
           silence_till: till)
  end

  def silenced_and_till?
    silenced? && (silence_till.to_i > Time.zone.now.to_i)
  end
end
