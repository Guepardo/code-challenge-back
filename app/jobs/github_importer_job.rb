class GithubImporterJob < ApplicationJob
  queue_as :default

  def perform(profile_id)
    profile = Profile.find(profile_id)
    Profiles::GithubImporter.call(profile)
  end
end
