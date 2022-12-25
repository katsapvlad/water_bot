# frozen_string_literal: true

require 'dotenv/load'
require 'i18n'
require 'telegram/bot'
require 'sidekiq'
require_relative '../workers/reminder_worker'
require_relative '../models/user'
require_relative '../modules/inline_button'

# Main commands for Water Bot
class Responser
  include InlineButton

  def initialize(bot, message, chat_id)
    @bot = bot
    @income_message = message
    @chat_id = chat_id
  end

  def start
    save_user unless current_user

    show_main_menu(false)
  end

  def set_reminder
    inline_message I18n.t(:select_time_interval), generate_inline_markup(
      [
        [InlineButton.half_hour_button, InlineButton.hour_button],
        [InlineButton.one_and_half_hour_button, InlineButton.two_hours_button],
        [InlineButton.back_button]
      ]
    ), true
  end

  def stop_reminder
    set_time(0)
    default_back_action(I18n.t(:reminders_disable))
  end

  def other_bots
    default_back_action(I18n.t(:single_bot))
  end

  def language
    inline_message I18n.t(:select_language), generate_inline_markup(
      [
        [InlineButton.english_button, InlineButton.russian_button], [InlineButton.back_button]
      ]
    ), true
  end

  def undefined_method
    send_message(I18n.t(:unknown_method))
  end

  def set_half_hour
    set_time(I18n.t(:half_hour_reminder), Constants::HALF_HOUR)
  end

  def set_hour
    set_time(I18n.t(:hour_reminder), Constants::HOUR)
  end

  def set_one_and_half_hour
    set_time(I18n.t(:one_and_half_hour_reminder), Constants::ONE_AND_HALF_HOUR)
  end

  def set_two_hours
    set_time(I18n.t(:two_hours_reminder), Constants::TWO_HOURS)
  end

  def show_main_menu(editless = true)
    inline_message I18n.t(:main_menu), generate_inline_markup(
      [
        [InlineButton.set_reminder_button],
        [InlineButton.language_button, InlineButton.stop_reminder_button],
        [InlineButton.support_button, InlineButton.rate_me_button],
        [InlineButton.other_bots_button, InlineButton.donate_button]
      ]
    ), editless
  end

  def set_english
    I18n.default_locale = :en
    current_user.update(language: Constants::EN)
    default_back_action(I18n.t(:change_language))
  end

  def set_russian
    I18n.default_locale = :ru
    current_user.update(language: Constants::RU)
    default_back_action(I18n.t(:change_language))
  end

  # TODO
  # Add functions below

  def support
    inline_message I18n.t(:support_description), generate_inline_markup(
      [
        [InlineButton.restart_button, InlineButton.feedback_button], [InlineButton.back_button]
      ]
    ), true
  end

  def feedback
    default_back_action(I18n.t(:feedback_description))
  end

  def restart
    User.destroy(current_user.id)
    @current_user = nil
    start
  end

  def donate
    not_implemented_yet
  end

  def rate_me
    not_implemented_yet
  end

  private

  def default_back_action(message)
    inline_message message, generate_inline_markup(
      [
        InlineButton.back_button
      ]
    ), true
  end

  def not_implemented_yet
    default_back_action(I18n.t(:not_implemented_yet))
  end

  def set_time(message, interval)
    default_back_action(message)
    current_user.update(reminder_interval: interval)
  end

  def save_user
    user = User.create(username: @income_message.from.username, telegram_id: @income_message.from.id,
                       reminder_interval: 0, language: 'en')

    new_user_notification(user.username, User.count)
    ReminderWorker.perform_async(@income_message.from.id, @chat_id)
  end

  def new_user_notification(username, count)
    Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_API_TOKEN']).api.send_message(chat_id: ENV['ADMIN_TELEGRAM_ID'],
                                                                                  text: "New user: #{username}\nAll users in bot: #{count}")
  end

  def send_message(text)
    @bot.api.send_message(chat_id: @chat_id, text: text, parse_mode: 'html')
  end

  def inline_message(message, inline_markup, editless = false)
    if editless
      return @bot.api.edit_message_text(
        chat_id: @chat_id,
        parse_mode: 'html',
        message_id: @income_message.message.message_id || @income_message.message_id,
        text: message,
        reply_markup: inline_markup
      )
    end
    @bot.api.send_message(
      chat_id: @chat_id,
      parse_mode: 'html',
      text: message,
      reply_markup: inline_markup
    )
  end

  def current_user
    @current_user ||= User.find_by(telegram_id: @income_message.from.id)
  end

  def generate_inline_markup(keyboard)
    Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: keyboard
    )
  end
end
