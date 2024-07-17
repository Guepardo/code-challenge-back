module Profiles
  class Create < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      Profile.create(params) ? Success(true) : Failure(errors: Profile.errors)
    end

    private

    attr_reader :params
  end
end
