# frozen_string_literal: true

require_relative 'responser'

# Router is responsible for preparing and sending messages to the Responser
class Router
  def self.processing(bot, income_message)
    chat_id = get_chat_id(income_message)
    responser = Responser.new(bot, income_message, chat_id)

    method = method_processor(income_message)

    if responser.respond_to?(method)
      responser.send(method)
    else
      responser.undefined_method
    end
  end

  def self.method_processor(income_message)
    message = callback_query_parser(income_message)
    method_parser(message)
  end

  def self.get_chat_id(income_message)
    if income_message.respond_to?('message')
      income_message.message.chat.id
    else
      income_message.chat.id
    end
  end

  def self.callback_query_parser(income_message)
    if income_message.respond_to?('message')
      income_message.data
    else
      income_message.text
    end
  end

  def self.method_parser(message)
    if message.start_with?('/')
      message[1..-1].to_s
    else
      'undefined_method'
    end
  end

  private_class_method :method_processor, :get_chat_id, :callback_query_parser, :method_parser
end
