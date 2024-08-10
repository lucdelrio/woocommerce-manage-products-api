# frozen_string_literal: true

class ProductCustomization < ApplicationRecord
  rails_admin do
    list do
      exclude_fields :last_sync
    end
  end
end
