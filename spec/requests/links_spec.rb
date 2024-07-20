
RSpec.describe "Links", type: :request do
  describe 'GET #show' do
    let(:nanoid) { 'some_nanoid' }
    let(:profile_url) { 'http://github.com/username' }

    context 'when the profile is found' do
      before do
        success = Dry::Monads::Success(profile_url)
        mock_lookup_service(success)
      end

      it 'redirects to the profile URL' do
        get "/#{nanoid}"

        expect(response).to redirect_to(profile_url)
      end
    end

    context 'when the profile is not found' do
      before do
        failure = Dry::Monads::Failure('Profile not found')
        mock_lookup_service(failure)
      end

      it 'renders plain text with status not found' do
        get "/#{nanoid}"
        expect(response.body).to eq("profile not found")
        expect(response.status).to eq(404)
      end
    end

    def mock_lookup_service(result)
      allow(Links::Lookup).to receive(:call).with(nanoid: nanoid).and_return(result)
    end
  end
end