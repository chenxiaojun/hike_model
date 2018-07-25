class Activity < ApplicationRecord
  belongs_to :user
  scope :user_visible, -> { where(auth_status: 'passed') }
  scope :search_keyword, ->(keyword) { where('name like ? or destination like ?', "%#{keyword}%", "%#{keyword}%") }

  def increment_page_views
    increment!(:page_views)
  end
end
