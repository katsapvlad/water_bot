# frozen_string_literal: true

logger = Logger.new($stdout)

logger.info('Debug message: 1')

require 'dotenv/load'

logger.info('Debug message: 2')

require 'erb'

logger.info('Debug message: 3')
require 'i18n'

logger.info('Debug message: 4')
require 'telegram/bot'

logger.info('Debug message: 5')
require 'active_record'

logger.info('Debug message: 6')
require_relative 'app/services/responser'

logger.info('Debug message: 7')
require_relative 'app/services/router'

logger.info('Debug message: 8')
require_relative 'app/modules/inline_button'

logger.info('Debug message: 9')
require_relative 'config/constants'

db_config = YAML.safe_load(ERB.new(File.read('config/database.yml.erb')).result)
logger.info('Debug message: 10')
ActiveRecord::Base.establish_connection(db_config)
logger.info('Debug message: 11')
I18n.load_path = Dir["#{File.expand_path('config/locales')}/*.yml"]
logger.info('Debug message: 12')
I18n.default_locale = :en

logger.info('Debug message: 13')

logger.info('Bot started')

# loop do
  Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_API_TOKEN']) do |bot|
    logger.info('Im into bot')
    bot.listen do |rqst|
      Thread.start(rqst) do |income_message|
        Router.processing(bot, income_message)
      rescue StandardError => e
        logger.error(e)
      end
    end
  end
# rescue StandardError => e
  # logger.error(e)
# end
