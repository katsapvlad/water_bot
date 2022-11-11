# frozen_string_literal: true

require 'dotenv/load'
require 'erb'
require 'i18n'
require 'telegram/bot'
require 'active_record'
require_relative 'app/services/responser'
require_relative 'app/services/router'
require_relative 'app/modules/inline_button'
require_relative 'config/constants'


logger = Logger.new($stdout)

db_config = YAML.safe_load(ERB.new(File.read('config/database.yml.erb')).result)
ActiveRecord::Base.establish_connection(db_config)
I18n.load_path = Dir["#{File.expand_path('config/locales')}/*.yml"]
I18n.default_locale = :en

logger.info('Bot started')

# loop do
  Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_API_TOKEN']) do |bot|
    bot.listen do |rqst|
      Thread.start(rqst) do |income_message|
        Router.processing(bot, income_message)
      rescue StandardError => e
        logger.error(e)
      end
    end
  end
# rescue StandardError => e
#   logger.error(e)s
# end
