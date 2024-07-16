class Profile < ApplicationRecord
  with_options presence: true, uniqueness: { case_sensitive: false } do |profile|
    profile.validates :username, :profile_url
  end

  with_options numericality: { greater_than_or_equal_to: 0 } do |profile|
    profile.validates :fallowers_count, :fallowing_count, :stars_count, :year_contributions_count
  end

  with_options length: { maximum: 2048 } do |profile|
    profile.validates :avatar_url
    profile.validates :profile_url
  end

  validates :profile_url, format: {
    with: %r{\Ahttps://github\.com/[a-zA-Z0-9_-]+\z},
    message: :invalid_profile_url
  }

  validates :username, length: { maximum: 255 }
  validates :location, length: { maximum: 255 }, if: -> { location.present? }
  validates :organization_name, length: { maximum: 255 }, if: -> { organization_name.present? }
end
