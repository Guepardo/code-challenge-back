# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'


RSpec.describe Profiles::CreateGithubImporterJob do
  let(:profile) { create(:profile, sync_status: sync_status) }

  ActiveJob::Base.queue_adapter = :test

  describe '#call' do
    context 'when sync can be started' do
      let(:sync_status) { 'idle' }

      it 'sets the sync status as pending' do
        described_class.call(profile)
        expect(profile.reload.sync_status).to eq('pending')
      end

      it 'enqueues the GithubImporterJob' do
        expect {
          described_class.call(profile)
        }.to have_enqueued_job(GithubImporterJob).with(profile.id)
      end

      it 'returns a Success' do
        result = described_class.call(profile)
        expect(result).to be_a(Dry::Monads::Success)
      end
    end

    context 'when sync can not be started' do
      let(:sync_status) { 'processing' }

      it 'does not change the sync status' do
        described_class.call(profile)
        expect(profile.reload.sync_status).to eq('processing')
      end

      it 'does not enqueue the GithubImporterJob' do
        expect {
          described_class.call(profile)
        }.not_to have_enqueued_job(GithubImporterJob)
      end

      it 'returns a Failure' do
        result = described_class.call(profile)
        expect(result).to be_a(Dry::Monads::Failure)
        expect(result.failure).to eq(:can_not_start_sync)
      end
    end
  end
end