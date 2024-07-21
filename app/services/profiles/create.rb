module Profiles
  class Create < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      create_profile
    end

    private

    attr_reader :params

    def create_profile
      profile = Profile.create(params)

      return create_github_importer_job(profile) if profile.valid?

      Failure(errors: profile.errors)
    end

    def create_github_importer_job(profile)
      CreateGithubImporterJob.call(profile)
                             .bind { Success(profile) }
    end
  end
end
