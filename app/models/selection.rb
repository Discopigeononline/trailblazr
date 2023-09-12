class Selection < ApplicationRecord
  belongs_to :itinerary
  belongs_to :activity

  has_many :messages
  has_many :reviews, dependent: :destroy

  before_destroy :reorder_days

  # need help with this, when add this line, in 'Add activity to itinerary' -> click 'update'  will go to 'Edit'
  validates :itinerary, uniqueness: { scope: :activity, message: "already contains this activity." }

  # accepts_nested_attributes_for :itinerary
  # accepts_nested_attributes_for :activity

  def same_activity_for_diff_days
    Selection.where(itinerary: self.itinerary, activity: self.activity).reject { |s| s.day.nil? }
  end

  def reorder_days
    selections = self.itinerary.selections
    selection_index = selections.order(:day).find_index { |i| i == self }
    selections.each_with_index do |selection, index|
      if index > selection_index
        selection.update!(day: index)
      end
    end
  end
end
