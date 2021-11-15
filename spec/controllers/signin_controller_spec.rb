# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SigninController, type: :controller do
  describe 'signin_controller test' do
    it '#create' do
      post :create,
           params: {
             first_name: "I'm",
             last_name: 'test user',
             'date_of_birth(1i)': '1999',
             'date_of_birth(2i)': '09',
             'date_of_birth(3i)': '09',
           }
      expect(response).to have_http_status(:found)
      expect(assigns(:newuser).class.name).to eq('Author')
      expect(assigns(:newuser).first_name).to eq("I'm")
      expect(assigns(:newuser).last_name).to eq('test user')
      #   ap json_body
    end

    it '#create2' do
      user = create(:author)

      expect(user.first_name).to eq('C. K.')
      expect(user.last_name).to eq('Louis')

      expect(response).to have_http_status(:ok)
      #   ap json_body
    end
  end
end
