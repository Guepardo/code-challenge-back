class Api::V1::ProfileSerializer < ActiveModel::Serializer
  attributes :id, :username, :profile_url, :organization_name, :location, :avatar_url, :followers_count,
             :fallowing_count, :stars_count, :year_contributions_count
end
