module Profiles
  class CreateGithubImporterJob < ApplicationService
    def initialize(profile)
      @profile = profile
    end

    def call
      return Failure(:can_not_start_sync) if can_not_start_sync?

      set_sync_status_as_pending
      GithubImporterJob.perform_later(profile.id)

      Success(true)
    end

    private

    attr_reader :profile

    def can_not_start_sync?
      profile.sync_status == 'processing' || profile.sync_status == 'pending'
    end

    def set_sync_status_as_pending
      profile.update(sync_status: 'pending')
    end
  end
end
