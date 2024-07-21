class LinksController < ApplicationController
  def show
    result = Links::Lookup.call(nanoid: params[:nanoid])

    if result.success?
      redirect_to result.value!, allow_other_host: true
    else
      render plain: 'profile not found', status: :not_found
    end
  end
end
