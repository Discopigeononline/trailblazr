class ItinerariesController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :set_itinerary, only: %i[show edit update destroy]

  def create
    @itinerary = Itinerary.new(itinerary_params)
    authorize @itinerary
    if @itinerary.save
      Collaboration.create(itinerary: @itinerary, user: current_user, role: "owner", email: current_user.email )
      redirect_to itinerary_path(@itinerary)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @itinerary = Itinerary.find(params[:id])
    @itinerary = Itinerary.find(params[:id])
    @owner = @itinerary.collaborations.find_by(role: "owner").user
    @collaboration = Collaboration.new(itinerary: @itinerary)
    @message = Message.new
    authorize @itinerary
    if params.include?(:notification_id)
      current_user.notifications.find(params[:notification_id]).mark_as_read!
    end

    @selections = Selection.where(itinerary_id: @itinerary)
    if @selections
      @selections_with_days = @selections.reject { |s| s.day.nil? }.group_by(&:day).sort_by(&:first)
      @selections_without_days = Selection.where(itinerary_id: @itinerary, day: nil)
    end

    @review = Review.new

    # The `geocoded` scope filters only activities with coordinates
    @markers = (@selections_with_days.map { |p| p[1] }.flatten).map do |selection|
      {
        lat: selection.activity.latitude,
        lng: selection.activity.longitude,
        info_window_html: render_to_string(partial: "selections/info_window_selected", locals: {selection: selection}),
        marker_html: render_to_string(partial: "activities/marker")
        # route_html: render_to_string(partial: "activities/route")
      }
    end
  end

  def edit
    authorize @itinerary
  end

  def update
    @itinerary.update(itinerary_params)
    if @itinerary.save
      redirect_to itinerary_path(@itinerary)
    else
      render :new, status: :unprocessable_entity
    end
    authorize @itinerary
  end

  def destroy
    @itinerary.destroy
    authorize @itinerary
    redirect_to activities_path
  end

  private

  def itinerary_params
    params.require(:itinerary).permit(:title)
  end

  def set_collaboration
    @collaboration = Collaboration.find(params[:collaboration_id])
  end

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
  end

  # New sweet alert
  def set_selections_with_days
    if @itinerary != nil?
      @selections = Selection.where(itinerary_id: @itinerary)
      @selections_with_days = @selections.reject { |s| s.day.nil? }.group_by(&:day).sort_by(&:first)
      @days = @selections_with_days.last[0] + 1
    end
  end
end
