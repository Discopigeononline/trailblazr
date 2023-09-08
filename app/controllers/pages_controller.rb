class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @activities = Activity.all
    @all_tags = []
    @activities.each do |activity|
      @all_tags << activity.tags
    end
    @tags = @all_tags.flatten.uniq

    @all_categories = []
    @activities.each do |activity|
      @all_categories << activity.category
    end
    @categories = @all_categories.uniq

    @all_locations = []
    @activities.each do |activity|
      @all_locations << activity.location
    end
    @locations = @all_locations.uniq
  end
end
