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

  describe 'POST /api/v1/profiles/:id/sync' do
    let(:profile) { create(:profile) }

    context 'when the profile exists and the job is successful' do
      before do
        allow(Profiles::CreateGithubImporterJob).to \
          receive(:call).with(profile).and_return(Dry::Monads::Success(profile))
      end

      it 'returns status created' do
        post "/api/v1/profiles/#{profile.id}/sync"
        expect(response).to have_http_status(:created)
      end

      it 'calls the CreateGithubImporterJob with the profile' do
        post "/api/v1/profiles/#{profile.id}/sync"
        expect(Profiles::CreateGithubImporterJob).to have_received(:call).with(profile)
      end
    end

    context 'when the profile exists and the job fails' do
      before do
        allow(Profiles::CreateGithubImporterJob).to \
          receive(:call).with(profile).and_return(Dry::Monads::Failure(:some_error))
      end

      it 'returns status unprocessable_entity' do
        post "/api/v1/profiles/#{profile.id}/sync"
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error in the response body' do
        post "/api/v1/profiles/#{profile.id}/sync"
        expect(response.body).to match(/some_error/)
      end
    end
  end
end
