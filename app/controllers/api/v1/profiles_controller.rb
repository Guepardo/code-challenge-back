class Api::V1::ProfilesController < ApplicationController
  before_action :set_profile, only: [:update]

  def index
    profiles = ProfilesFinder.filter(params)

    render json: {
      data: serialize_resource(profiles, Api::V1::ProfileSerializer), #TODO: have a better way to do this
      meta: pagination_meta(profiles)
    }
  end

  def create
    result = Profiles::Create.call(profile_params)

    if result.success?
      head :created
    else
      render json: result.failure[:errors].full_messages, status: :unprocessable_entity
    end
  end

  def update
    result = Profiles::Update.call(profile: @profile, params: profile_params)

    if result.success?
      head :ok
    else
      render json: result.failure[:errors].full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = Profile.find_by!(id: params[:id])
  end

  def profile_params
    params.require(:profile).permit(:username, :profile_url)
  end
end
