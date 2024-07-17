module Profiles
  class Create < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      profile = Profile.create(params)

      if profile.valid?
        Success(profile)
      else
        Failure(errors: profile.errors)
      end
    end

    private

    attr_reader :params
  end
end
