# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :username, :phone_number, :profile_pic

  def profile_pic
    return unless object.profile_pic.attached?

    Rails.application.routes.url_helpers.rails_blob_path(object.profile_pic,
                                                         only_path: true)
  end
end
