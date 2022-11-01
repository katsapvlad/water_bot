# frozen_string_literal: true

# Top-level documentation for CreateUser
class CreateUser < ActiveRecord::Migration[6.0]
  def self.up
    create_table :users do |t|
      t.string :telegram_id
      t.string :username
      t.integer :reminder_interval

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
