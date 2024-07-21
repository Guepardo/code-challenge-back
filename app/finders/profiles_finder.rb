class ProfilesFinder < ApplicationFinder
  DEFAULT_ITEMS_PER_PAGE = 6
  def initialize(filter_params)
    @filter_params = filter_params
  end

  def filter
    profiles = apply_filters(Profile.all)

    # TODO: unsafe code. should be refactored
    profiles
      .order('created_at DESC')
      .page(filter_params[:page])
      .per(filter_params[:per_page] || DEFAULT_ITEMS_PER_PAGE)
  end

  private

  attr_reader :filter_params

  def apply_filters(profiles)
    return profiles unless filter_params[:term].present?

    conditions = []
    conditions << profiles_table[:username].matches("%#{filter_params[:term]}%")
    conditions << profiles_table[:location].matches("%#{filter_params[:term]}%")
    conditions << profiles_table[:organization_name].matches("%#{filter_params[:term]}%")
    conditions << profiles_table[:profile_url].matches("%#{filter_params[:term]}%")

    combined_condition = conditions.reduce { |acc, condition| acc.or(condition) }

    profiles.where(combined_condition)
  end

  def profiles_table
    @profiles_table ||= Profile.arel_table
  end
end
