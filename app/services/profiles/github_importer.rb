module Profiles
  class GithubImporter < ApplicationService
    ALLOWED_SYNC_STATUS = %w[idle failure].freeze

    def initialize(profile)
      @profile = profile
    end

    def call
      return Failure(:can_not_start_sync) unless can_start_sync?

      result = import

      if result.success?
        set_sync_status(:success)
      else
        set_sync_status(:failure)
      end

      result
    rescue StandardError => e
      set_sync_status(:failure)
      raise e
    end

    private

    attr_reader :profile

    def import
      Github::RetreiveDataFromHtml.call(url: profile.profile_url)
        .bind do |data|
          Profiles::Update.call(profile: profile, params: data)
        end
        .to_result
    end

    def can_start_sync?
      ALLOWED_SYNC_STATUS.include?(profile.sync_status)
    end

    def set_sync_status(status)
      profile.update(sync_status: status)
    end
  end
end
