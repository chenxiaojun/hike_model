class Activity < ApplicationRecord
  belongs_to :user
  has_many :activity_joins, dependent: :destroy
  scope :user_visible, -> { where(auth_status: 'passed') }
  scope :search_keyword, ->(keyword) { where('name like ? or destination like ?', "%#{keyword}%", "%#{keyword}%") }

  def increment_page_views
    increment!(:page_views)
  end

  # 活动的状态 报名中，进行中，已结束，已满员，已取消
  def activity_status
    if canceled
      'canceled'
    elsif activity_joins.passed.count >= mem_limit
      'overload'
    elsif start_date > Time.zone.today
      'applying'
    elsif Time.zone.today > end_date
      'finished'
    else
      'doing'
    end
  end
end
