require 'spec_helper'
require 'rails_helper'

RSpec.describe Profiles::Update do
  let(:profile) { create(:profile) }
  let(:params) { { username: 'test_username', profile_url: 'https://github.com/test_username' } }

  describe '.call' do
    it 'update a profile' do
      result = described_class.call(profile:, params:)
      expect(result.success?).to be_truthy
    end
  end
end
