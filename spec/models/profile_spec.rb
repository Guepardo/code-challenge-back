require 'rails_helper'

RSpec.describe Profile, type: :model do
  subject { described_class.new }

  describe 'validations' do
    context 'presence and uniqueness' do
      let(:username) { 'test_username' }
      let(:profile_url) { 'https://github.com/test_username' }

      before do
        create(:profile, username:, profile_url:)

        subject.username = username
        subject.profile_url = profile_url
      end

      it { should validate_uniqueness_of(:nanoid) }

      it 'validates presence and uniqueness of username' do
        expect(subject).to validate_presence_of(:username)
        expect(subject).to validate_uniqueness_of(:username).case_insensitive
      end

      it 'validates presence and uniqueness of profile_url' do
        expect(subject).to validate_presence_of(:profile_url)
        expect(subject).to validate_uniqueness_of(:profile_url).case_insensitive
      end
    end

    context 'numericality' do
      it { should validate_numericality_of(:followers_count).is_greater_than_or_equal_to(0) }
      it { should validate_numericality_of(:following_count).is_greater_than_or_equal_to(0) }
      it { should validate_numericality_of(:stars_count).is_greater_than_or_equal_to(0) }
      it { should validate_numericality_of(:year_contributions_count).is_greater_than_or_equal_to(0) }
    end

    context 'length validations' do
      it { should validate_length_of(:avatar_url).is_at_most(2048) }
      it { should validate_length_of(:profile_url).is_at_most(2048) }
      it { should validate_length_of(:username).is_at_most(255) }
      it { should validate_length_of(:location).is_at_most(255).allow_nil }
      it { should validate_length_of(:organization_name).is_at_most(255).allow_nil }
    end

    context 'format validation' do
      it { should allow_value('https://github.com/username').for(:profile_url) }
      it { should_not allow_value('http://github.com/username').for(:profile_url) }
      it { should_not allow_value('https://other.com/username').for(:profile_url) }
      it { should_not allow_value('invalid_url').for(:profile_url) }
    end
  end

  describe 'bofore create callback' do
    subject { create(:profile) }

    it 'generates nanoid' do
      expect(subject.nanoid).to be_present
      expect(subject.nanoid.length).to eq(5)
    end
  end
end
