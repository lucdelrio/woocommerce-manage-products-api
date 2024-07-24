# frozen_string_literal: true

class Attachment < ApplicationRecord
  rails_admin do
    list do
      exclude_fields :media_hash, :created_at, :updated_at
    end
  end
end
