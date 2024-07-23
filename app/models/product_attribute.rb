# frozen_string_literal: true

class ProductAttribute < ApplicationRecord
  rails_admin do
    list do
      exclude_fields :attribute_hash, :created_at, :updated_at
    end
  end
end
