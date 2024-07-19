class ProfilesFinder < ApplicationFinder
  def initialize(filter_params)
    @filter_params = filter_params
  end

  def filter
    profiles = apply_filters(Profile.all)

    # TODO: unsafe code. should be refactored
    profiles.page(filter_params[:page]).per(filter_params[:per_page] || DEFAULT_ITEMS_PER_PAGE)
  end

  private

  attr_reader :filter_params

  def apply_filters(profiles)
    conditions = []

    if filter_params[:username].present?
      conditions << profiles_table[:username].matches("%#{filter_params[:username]}%")
    end

    if filter_params[:location].present?
      conditions << profiles_table[:location].matches("%#{filter_params[:location]}%")
    end

    if filter_params[:organization_name].present?
      conditions << profiles_table[:organization_name].matches("%#{filter_params[:organization_name]}%")
    end

    return profiles if conditions.empty?

    combined_condition = conditions.reduce { |acc, condition| acc.or(condition) }

    profiles.where(combined_condition)
  end

  def profiles_table
    @profiles_table ||= Profile.arel_table
  end
end
