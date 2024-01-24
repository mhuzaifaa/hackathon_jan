# frozen_string_literal: true

require 'openai'
require 'csv'

class OpenaiService
  attr_reader :client

  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def generate_response(user_prompt)
    messages = [
      { role: 'system', content: "Providing user downloaded story titles history. Headers are Download Date, Story Title. #{user_download_data}" },
      { role: 'system', content: "Providing story data. Headers are Publish Date, Story Title, Keywords. #{story_recommendation_data}" },
      { role: 'user', content: user_prompt }
    ]
  
    Rails.logger.info "Messages: #{messages}" 

    # raise messages.inspect
    response = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo-16k',
        messages: messages
      }
    )

    response
  end

  private

  def read_csv_file
    csv_file_path = Rails.root.join('public', 'user.csv')
    CSV.read(csv_file_path, headers: true)
  end

  def user_download_data
    read_csv_file.map do |row|
      [row['Download Date'], row['Story Title']].to_s
    end.take(20)
  end

  def story_recommendation_data
    read_csv_file.map do |row|
      row.to_s
    end.take(100)
  end
end
