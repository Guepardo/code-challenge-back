# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe Links::Lookup do
  describe '.call' do
    let(:profile) { create(:profile) }
    let(:nanoid) { profile.nanoid }
    let(:profile_url) { profile.profile_url }

    before do
      allow(Rails.cache).to receive(:write)
      allow(Profile).to receive(:find_by)
    end

    context 'when the profile URL is found in the cache' do
      before do
        allow(Rails.cache).to receive(:read).with(nanoid).and_return(profile_url)
      end

      it 'returns the cached profile URL' do
        result = described_class.new(nanoid: nanoid).call
        expect(result).to be_a Dry::Monads::Success
        expect(result.value!).to eq(profile_url)
      end
    end

    context 'when the profile URL is not in the cache but found in the database' do
      before do
        allow(Rails.cache).to receive(:read).with(nanoid).and_return(nil)
        allow(Rails.cache).to receive(:write).with(nanoid, profile_url, expires_in: described_class::LOOKUP_EXPIRES_IN)
      end

      it 'finds the profile in the database, updates the cache, and returns the URL' do
        result = described_class.new(nanoid: nanoid).call
        expect(result).to be_a Dry::Monads::Success
        expect(result.value!).to eq(profile_url)
        expect(Rails.cache).to have_received(:write).with(nanoid, profile_url, expires_in: described_class::LOOKUP_EXPIRES_IN)
      end
    end

    context 'when the profile URL is not in the cache and not found in the database' do
      let(:nanoid) { 'fake_id' }

      before do
        allow(Rails.cache).to receive(:read).with(nanoid).and_return(nil)
      end

      it 'returns a failure indicating that the profile was not found' do
        result = described_class.new(nanoid: nanoid).call
        expect(result).to be_a Dry::Monads::Failure
        expect(result.failure).to eq('Profile not found')
      end
    end
  end
end