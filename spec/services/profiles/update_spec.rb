require 'spec_helper'
require 'rails_helper'

RSpec.describe Profiles::Update do
  let(:profile) { create(:profile, sync_status: :failure) }
  let(:valid_params) { { username: 'test_username', profile_url: 'https://github.com/test_username' } }
  let(:invalid_params) { { username: '', profile_url: '' } }

  describe '.call' do
    context 'when params is valid' do
      it 'update a profile' do
        result = described_class.call(profile:, params: valid_params)
        expect(result).to be_success
      end

      it 'calls CreateGithubImporterJob' do
        expect(Profiles::CreateGithubImporterJob).to \
          receive(:call).with(profile).and_return(Dry::Monads::Success(true))

        expect{ described_class.call(profile:, params: valid_params) }.to \
          change{ profile.sync_status }.from('failure').to('idle')
      end
    end

    context 'when params is invalid' do
      it 'does not call CreateGithubImporterJob' do
        expect(Profiles::CreateGithubImporterJob).not_to receive(:call)
        described_class.call(profile:, params: invalid_params)
      end

      it 'returns a Failure' do
        result = described_class.call(profile:, params: invalid_params)
        expect(result).to be_failure
      end
    end
  end
end
