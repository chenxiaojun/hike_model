class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator
  include UserCreator
  include UserCountable
  include User::Favorite
  mount_uploader :avatar, ImageUploader

  has_many :topics, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :actions, dependent: :destroy
  has_one :counter, class_name: 'UserCounter', dependent: :destroy

  action_store :like,     :topic, counter_cache: true
  action_store :follow,   :user,  counter_cache: 'followers_count', user_counter_cache: 'following_count'

  # 刷新访问时间
  def touch_visit!
    interval_day = (Time.zone.today - last_visit.to_date).to_i
    increase_login_days if interval_day >= 1 || counter.login_days.zero?
    self.last_visit = Time.zone.now
    save
  end

  def avatar_path
    avatar.url.presence || wx_avatar
  end

  def action_likes
    actions.where(action_type: 'like')
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
