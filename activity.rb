class Activity < ApplicationRecord
  belongs_to :user
  scope :user_visible, -> { where(auth_status: 'passed') }
  scope :search_keyword, ->(keyword) { where('name like ? or destination like ?', "%#{keyword}%", "%#{keyword}%") }

  def increment_page_views
    increment!(:page_views)
  end

  # 活动的状态 报名中，进行中, 已满员，已结束，已取消
  def activity_status
  end
end
