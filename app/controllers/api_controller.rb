# app/controllers/api_controller.rb

require 'rest-client'
require_relative '../services/openai_service'

class ApiController < ApplicationController
  def get_recommendation
    user_data = params[:user_data] # You can adjust this based on your FE request format

    # Generate a prompt using user data
    prompt = build_prompt(user_data)

    # Make a request to OpenAI
    response = send_to_openai(prompt)
    Rails.logger.info "response: #{response}" 

      render json: { recommendation: response['choices'][0]['message'] }
  end

  private

  def build_prompt(user_data)
    "Generate 5 recommended stories based on the user's downloaded history and the similarity between story keywords for the user's downloaded story (i.e., #{user_data}).
    Please ensure that the recommended stories do not include the user's downloaded story title Output should always be an array of 'recommendations: [story_title, story_title2]'"
  end

  def send_to_openai(prompt)
    OpenaiService.new.generate_response(prompt)
  end
end
