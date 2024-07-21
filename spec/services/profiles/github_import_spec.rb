require 'rails_helper'

RSpec.describe Profiles::GithubImporter, type: :service do
  let(:profile) { create(:profile) }

  describe '#call' do
    context 'when sync can start' do
      context 'when import is successful' do
        before do
          allow(Github::RetreiveDataFromHtml).to receive(:call).and_return(Dry::Monads::Success(data: {}))
          allow(Profiles::Update).to receive(:call).and_return(Dry::Monads::Success(true))
        end

        it 'returns the success' do
          result = described_class.call(profile)
          expect(result).to be_success
          expect(profile.sync_status).to eq('success')
        end
      end

      context 'when import fails' do
        context 'when Github::RetreiveDataFromHtml fails' do
          before do
            allow(Github::RetreiveDataFromHtml).to receive(:call).and_return(Dry::Monads::Failure(:not_found_profile))
          end

          it 'returns the failure' do
            result = described_class.call(profile)
            expect(result).to be_failure
            expect(result.failure).to eq(:not_found_profile)
            expect(profile.sync_status).to eq('failure')
          end
        end

        context 'when Profiles::Update fails' do
          before do
            allow(Github::RetreiveDataFromHtml).to receive(:call).and_return(Dry::Monads::Success(data: {}))
            allow(Profiles::Update).to receive(:call).and_return(Dry::Monads::Failure(false))
          end

          it 'returns the failure' do
            result = described_class.call(profile)
            expect(result).to be_failure
            expect(result.failure).to eq(false)
            expect(profile.sync_status).to eq('failure')
          end
        end
      end
    end

    context 'when sync cannot start' do
      let(:profile) { create(:profile, sync_status: 'processing') }

      it 'returns failure with the appropriate error' do
        result = described_class.call(profile)
        expect(result).to be_failure
        expect(result.failure).to eq(:can_not_start_sync)
        expect(profile.reload.sync_status).to eq('processing')
      end
    end

    context 'when an exception occurs during import' do
      before do
        allow(Github::RetreiveDataFromHtml).to receive(:call).and_raise(StandardError.new('Something went wrong'))
      end

      it 'sets the sync status as failure' do
        expect { described_class.call(profile) }.to raise_error(StandardError, 'Something went wrong')
        expect(profile.reload.sync_status).to eq('failure')
      end
    end
  end
end
