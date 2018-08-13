class Activity < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :activity_joins, dependent: :destroy
  has_many :comments, as: :target, dependent: :destroy
  scope :user_visible, -> { where(auth_status: 'passed') }
  scope :search_keyword, ->(keyword) { where('name like ? or destination like ?', "%#{keyword}%", "%#{keyword}%") }

  def increment_page_views
    increment!(:page_views)
  end

  def increment_join_numbers
    increment!(:join_numbers)
  end

  def increment_apply_numbers
    increment!(:apply_numbers)
  end

  # 活动的状态 报名中，进行中，已结束，已满员，已取消
  def activity_status
    if canceled
      'canceled'
    elsif join_numbers >= mem_limit
      'overload'
    elsif begin_time > Time.zone.now
      'applying'
    elsif Time.zone.now > end_time
      'finished'
    else
      'doing'
    end
  end

  def allow_cancel?
    %[applying doing overload].include? activity_status
  end

  def allow_join?
    activity_status.eql?('applying')
  end

  def user_joined?(user)
    activity_joins.where(user: user).exists?
  end

  def total_comments
    comments_count + replies_count
  end
end
