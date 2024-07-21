require 'rails_helper'

RSpec.describe Github::RetreiveDataFromHtml do
  let(:profile_url) { 'https://github.com/torvalds' }
  let(:html_fixture_path) { Rails.root.join('spec', 'fixtures', 'github_profiles') }
  let(:html_content) { File.read("#{html_fixture_path}/linux_torvals.html") }

  before do
    allow(DownloadDynamicHtml).to receive(:download).and_return(html_content)
  end

  it 'retrieves the correct data from the HTML' do
    expected_data = {
      stars_count: 7,
      followers_count: 212000,
      following_count: 0,
      year_contributions_count: 2724,
      avatar_url: 'https://avatars.githubusercontent.com/u/1024025?v=4',
      location: 'Portland, OR',
      organization_name: 'Linux Foundation'
    }

    result = described_class.call(url: profile_url)

    expect(result.value!).to eq(expected_data)
  end

  context 'when location and organization is not present in the profile HTML' do
    let(:html_content) { File.read("#{html_fixture_path}/other_user.html") }

    it 'retrieves the correct data from the HTML' do
      expected_data = {
        stars_count: 2,
        followers_count: 4,
        following_count: 13,
        year_contributions_count: 152,
        avatar_url: 'https://avatars.githubusercontent.com/u/98629093?v=4',
        location: '',
        organization_name: ''
      }

      result = described_class.call(url: profile_url)

      expect(result.value!).to eq(expected_data)
    end
  end

  context 'when profile does not exist' do
    let(:html_content) { File.read("#{html_fixture_path}/not_found_profile.html") }

    it 'returns a failure' do
      result = described_class.call(url: profile_url)

      expect(result).to be_a Dry::Monads::Failure
      expect(result.failure).to eq(:not_found_profile)
    end
  end
end
