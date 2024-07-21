module Profiles
  class Update < ApplicationService
    def initialize(profile:, params:)
      @profile = profile
      @params = params
    end

    def call
      return create_github_importer_job(profile) if profile.update(params)

      Failure(errors: profile.errors)
    end

    private

    attr_reader :params, :profile

    def create_github_importer_job(profile)
      profile.idle!
      CreateGithubImporterJob.call(profile)
    end
  end
end
