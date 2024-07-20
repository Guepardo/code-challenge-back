module Links
  class Lookup < ApplicationService
    def initialize(nanoid:)
      @nanoid = nanoid
    end

    def call
      find_profile_url
    end

    private

    attr_reader :nanoid

    def find_profile_url
      url = find_from_cache

      return Success(url) if url

      url = find_profile

      return Failure('Profile not found') unless url

      store_in_cache(url)

      Success(url)
    end

    def find_profile
      profile = Profile.select(:profile_url).find_by(nanoid:)
      profile.profile_url if profile
    end

    def find_from_cache
      Rails.cache.read(nanoid)
    end

    LOOKUP_EXPIRES_IN = 1.hour

    def store_in_cache(url)
      Rails.cache.write(nanoid, url, expires_in: LOOKUP_EXPIRES_IN)
    end
  end
end
