require 'rails_helper'

RSpec.describe Profiles::Create, type: :service do
  describe '.call' do
    let(:valid_params) { { username: 'test_username', profile_url: 'https://github.com/test_username' } }
    let(:invalid_params) { { username: '', profile_url: '' } }

    context 'when profile is valid' do
      it 'creates a profile' do
        expect{ described_class.call(valid_params) }.to change(Profile, :count).by(1)
      end

      it 'calls CreateGithubImporterJob' do
        expect(Profiles::CreateGithubImporterJob).to \
          receive(:call).and_return(Dry::Monads::Success(true))

        described_class.call(valid_params)
      end
    end

    context 'when profile is invalid' do
      it 'does not call CreateGithubImporterJob' do
        expect(Profiles::CreateGithubImporterJob).not_to receive(:call)

        described_class.call(invalid_params)
      end

      it 'returns a Failure with profile errors' do
        result = described_class.call(invalid_params)
        expect(result).to be_failure
      end
    end
  end
end
