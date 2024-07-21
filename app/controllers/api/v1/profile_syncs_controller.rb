class Api::V1::ProfileSyncsController < ApplicationController
  before_action :set_profile, only: [:create]

  def create
    result = Profiles::CreateGithubImporterJob.call(@profile)

    if result.success?
      head :created
    else
      render json: { error: result.failure }, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = Profile.find_by!(id: params[:id])
  end
end
