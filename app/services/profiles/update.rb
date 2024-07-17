module Profiles
  class Update < ApplicationService
    def initialize(profile:, params:)
      @profile = profile
      @params = params
    end

    def call
      profile.update(params) ? Success(true) : Failure(errors: profile.errors)
    end

    private

    attr_reader :params, :profile
  end
end
