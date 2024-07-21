require 'rails_helper'

RSpec.describe GithubImporterJob, type: :job do
  let(:profile) { create(:profile) }

  describe '#perform' do
    it 'calls Profiles::GithubImporter with the given profile' do
      expect(Profiles::GithubImporter).to receive(:call).with(profile)

      GithubImporterJob.perform_now(profile.id)
    end

    it 'raises an error if the profile is not found' do
      expect { GithubImporterJob.perform_now(-1) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'enqueueing the job' do
    it 'enqueues the job' do
      expect do
        GithubImporterJob.perform_later(profile.id)
      end.to have_enqueued_job.with(profile.id).on_queue('default')
    end
  end
end
