# frozen_string_literal: true

require 'telegram/bot'
require 'sidekiq'
require_relative '../models/user'
require_relative '../../config/constants'
require 'i18n'

I18n.load_path = Dir["#{File.expand_path('config/locales')}/*.yml"]
I18n.default_locale = :en

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

db_config = YAML.safe_load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(db_config)

# Water Bot reminder logic
class ReminderWorker
  include Sidekiq::Worker
  include Constants

  def perform(telegram_id, chat_id)
    loop do
      reminder_interval = User.find_by(telegram_id: telegram_id).reminder_interval

      if reminder_interval.zero?
        sleep 30
      else
        sleep reminder_interval
        next if User.find_by(telegram_id: telegram_id).reminder_interval.zero?

        delete_excess_message(chat_id) if @message_id
        @message_id = send_message(chat_id, telegram_id)
      end
    end
  end

  private

  def send_message(chat_id, telegram_id)
    I18n.default_locale = User.find_by(telegram_id: telegram_id).language.to_sym
    Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_API_TOKEN']).api.send_message(
      chat_id: chat_id,
      text: I18n.t(:drinking_time)
    )['result']['message_id']
  end

  def delete_excess_message(chat_id)
    Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_API_TOKEN']).api.delete_message(
      chat_id: chat_id,
      message_id: @message_id
    )
  end
end
