class SelectionsController < ApplicationController
  def index
    @selections = policy_scope(Selection)

    # @selections = Selection.where(itinerary_id: params[:itinerary_id]) # replace with params[id] when get itinerary
    # @itinerary = Itinerary.find(params[:itinerary_id])

    # @itinerary_activities = selections.map do |selection|
    #   Activity.find(selection.activity_id)
    # end

    # new try

    @itinerary = Itinerary.find(params[:itinerary_id])
    @selections = Selection.where(itinerary_id: @itinerary)
  end

  def create
    @selection = Selection.new(selection_params)
    @activity = Activity.find(params[:activity_id])
    @selection.activity = @activity
    authorize @selection

    if @selection.save
      redirect_to itinerary_path(@selection.itinerary)
    else
      render "activities/show", status: :unprocessable_entity
    end
  end

  # def create
  #   @itinerary = Itinerary.find(params[:itinerary_id])
  #   @activity = Activity.find(params[:activity_id])
  #   @selection = Selection.new(params[:selection])
  #   # @selection.update(day: params[:selection][:day])

  #   # @selection.update(selection_params.slice(:day))
  #   Selection.create(itinerary_id: @itinerary.id, activity_id: @activity.id)
  #   redirect_to itinerary_path(@itinerary)

  #   authorize @selection
  # end

  # GET selections/:id/edit
  def edit
    # @itinerary = Itinerary.find(params[:itinerary_id])
    @selection = Selection.find(params[:id])

    @selections = Selection.where(itinerary_id: @selection.itinerary_id)

    @selections_with_days = @selections.reject { |s| s.day.nil? }.group_by(&:day).sort_by(&:first)

    @days = []
    if @selections_with_days.empty?
      @days << 1
    else
      last_day = @selections_with_days.last[0]
      @days = (1..last_day + 1)
      # @days.each_with_index do |day, index|
      #     day = index + 1
      #   end
    end

    authorize @selection
  end

  # PATCH slections/:id
  def update
    @selection = Selection.find(params[:id])
    authorize @selection
    if @selection.update(selection_params)
      redirect_to itinerary_path(@selection.itinerary), notice: "Activity added to day plan"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # def destroy_wish_list_selection
  #   @wish_list_selection = Selection.find_by(activity_id: params[:id])

  #   if  @wish_list_selection.destroy
  #     redirect_to itinerary_path(@wish_list_selection.itinerary_id)
  #   end

  #   authorize @wish_list_selection
  # end

  def destroy
    @day_selection = Selection.find(params[:id])

    if @day_selection.destroy
      redirect_to itinerary_path(@day_selection)
    end
    authorize @day_selection
  end

  def new
    @selection = Selection.new
    @itinerary = Itinerary.find(params[:itinerary_id])
    @activity = Activity.find(params[:activity_id])
    authorize @selection
  end

  private

  def selection_params
    params.require(:selection).permit(:itinerary_id, :activity_id, :day)
  end
end
