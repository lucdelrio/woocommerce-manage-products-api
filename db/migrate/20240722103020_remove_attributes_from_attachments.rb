

# frozen_string_literal: true

class RemoveAttributesFromAttachments < ActiveRecord::Migration[7.1]
  def up
    remove_column :attachments, :index
    remove_reference :attachments, :product
  end

  def down
    add_column    :attachments, :index,      :index
  end
end
