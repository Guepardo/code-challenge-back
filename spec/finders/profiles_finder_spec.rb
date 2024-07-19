# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe ProfilesFinder do
  describe '.filter' do
    let!(:profiles) { create_list(:profile, 10) }
    let(:last_profile) { profiles.last }
    let(:first_profile) { profiles.first }

    context 'with only one filter' do
      it 'returns a profile by username' do
        profiles = described_class.filter(username: first_profile.username)
        expect(profiles.count).to eq(1)
      end

      it 'returns a profile by location' do
        profiles = described_class.filter(location: first_profile.location)
        expect(profiles.count).to eq(1)
      end

      it 'returns a profile by organization name' do
        profiles = described_class.filter(organization_name: first_profile.organization_name)
        expect(profiles.count).to eq(1)
      end
    end

    context 'with only one filter and partial match' do
      it 'returns a profile by username' do
        profiles = described_class.filter(username: first_profile.username[0..10])
        expect(profiles.count).to eq(1)
      end

      it 'returns a profile by location' do
        profiles = described_class.filter(location: first_profile.location[0..10])
        expect(profiles.count).to eq(1)
      end

      it 'returns a profile by organization name' do
        profiles = described_class.filter(organization_name: first_profile.organization_name[0..10])
        expect(profiles.count).to eq(1)
      end
    end

    context 'with multiple filters' do
      it 'returns two profiles by username and location' do
        profiles = described_class.filter(username: first_profile.username, location: last_profile.location)
        expect(profiles.count).to eq(2)
      end

      it 'returns two profiles by location and organization name' do
        profiles = described_class.filter(username: first_profile.username,
                                          organization_name: last_profile.organization_name)
        expect(profiles.count).to eq(2)
      end
    end

    context 'with no filters' do
      it 'returns all profiles' do
        profiles = described_class.filter({})
        expect(profiles.count).to eq(10)
      end
    end
  end
end
