class User
  module Favorite
    extend ActiveSupport::Concern

    included do
      action_store :favorite, :activity, counter_cache: true
    end

    # 收藏
    def favorite(target)
      return false if target.blank?
      return false if target.user_id == id
      create_action(:favorite, target: target)
    end

    # 取消收藏
    def unfavorite(target)
      return false if target.blank?
      destroy_action(:favorite, target: target)
    end

    # 是否收藏过
    def favorite?(favorite)
      find_action(:favorite, target: favorite).present?
    end
  end
end