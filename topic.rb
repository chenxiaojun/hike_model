class Topic < ApplicationRecord
  include TopicCountable
  include Excellentable

  belongs_to :user
  has_one    :topic_counter, dependent: :destroy
  serialize :images, JSON

  default_scope { where.not(status: 'failed') } unless ENV['CURRENT_PROJECT'] == 'cms'

  enum body_type: { long: 'long', short: 'short' }
  enum status: { pending: 'pending', passed: 'passed', failed: 'failed' }

  def self.excellent
    where(excellent: true)
  end

  def long?
    body_type.eql? 'long'
  end

  def total_comments
    comments_count + replies_count
  end

  def total_views
    topic_counter.page_views + topic_counter.view_increment
  end
end
