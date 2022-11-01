# frozen_string_literal: true

# Top-level documentation for AddLanguageColumn
class AddLanguageColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :language, :string
  end
end
