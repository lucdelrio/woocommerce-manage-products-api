# frozen_string_literal: true

class ProductAttributeTerm < ApplicationRecord
  rails_admin do
    list do
      exclude_fields :term_hash, :created_at, :updated_at
    end
  end
end
