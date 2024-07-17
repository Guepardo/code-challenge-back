require 'rails_helper'

RSpec.describe 'Api::V1::Profiles', type: :request do
  let(:valid_params) { { username: 'test_username', profile_url: 'https://github.com/test_username' } }
  let(:invalid_params) { { username: 'test_username', profile_url: 'https://google.com' } }

  describe 'POST /api/v1/profiles' do
    context 'with valid parameters' do
      it 'creates a new profile' do
        expect { post '/api/v1/profiles', params: { profile: valid_params } }
          .to change(Profile, :count).by(1)
      end

      it 'returns status code 201' do
        post '/api/v1/profiles', params: { profile: valid_params }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new profile' do
        expect { post '/api/v1/profiles', params: { profile: invalid_params } }
          .not_to change(Profile, :count)
      end

      it 'returns status code 422' do
        post '/api/v1/profiles', params: { profile: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /api/v1/profiles/:id' do
    let(:profile) { create(:profile) }

    context 'with valid parameters' do
      it 'updates the profile' do
        put "/api/v1/profiles/#{profile.id}", params: { profile: valid_params }
        profile.reload
        expect(profile.username).to eq(valid_params[:username])
        expect(profile.profile_url).to eq(valid_params[:profile_url])
      end

      it 'returns status code 200' do
        put "/api/v1/profiles/#{profile.id}", params: { profile: valid_params }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'not updates the profile' do
        put "/api/v1/profiles/#{profile.id}", params: { profile: invalid_params }
        profile.reload
        expect(profile.username).not_to eq(invalid_params[:username])
        expect(profile.profile_url).not_to eq(invalid_params[:profile_url])
      end

      it 'returns status code 422' do
        put "/api/v1/profiles/#{profile.id}", params: { profile: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end