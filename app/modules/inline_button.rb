# frozen_string_literal: true

require 'i18n'

I18n.load_path = Dir["#{File.expand_path('config/locales')}/*.yml"]

# buttons for Water Bot
module InlineButton
  def self.set_reminder_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:set_reminder), callback_data: '/set_reminder')
  end

  def self.stop_reminder_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:stop_reminder), callback_data: '/stop_reminder')
  end

  def self.language_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:language), callback_data: '/language')
  end

  def self.rate_me_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:rate_me), callback_data: '/rate_me')
  end

  def self.feedback_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:feedback), callback_data: '/feedback')
  end

  def self.donate_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:donate), callback_data: '/donate')
  end

  def self.other_bots_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:other_bots), callback_data: '/other_bots')
  end

  def self.back_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:back), callback_data: '/show_main_menu')
  end

  def self.half_hour_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:half_hour), callback_data: '/set_half_hour')
  end

  def self.hour_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:hour), callback_data: '/set_hour')
  end

  def self.one_and_half_hour_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:one_and_half_hour),
                                                   callback_data: '/set_one_and_half_hour')
  end

  def self.two_hours_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:two_hours), callback_data: '/set_two_hours')
  end

  def self.english_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:english), callback_data: '/set_english')
  end

  def self.russian_button
    Telegram::Bot::Types::InlineKeyboardButton.new(text: I18n.t(:russian), callback_data: '/set_russian')
  end
end
