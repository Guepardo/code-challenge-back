# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe Profiles::Create do
  let(:params) { { username: 'test_username', profile_url: 'https://github.com/test_username' } }

  describe '.call' do
    it 'creates a new profile' do
      result = described_class.call(params)
      expect(result.success?).to be_truthy
    end
  end
end
