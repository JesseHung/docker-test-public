class TimeSlot < ApplicationRecord
  belongs_to :user

  def self.has_overlap?(start_at: nil, end_at: nil)
    if start_at.blank? || end_at.blank?
      raise "請提供起始時間和結束時間"
    end

    start_at = start_at.to_i
    end_at = end_at.to_i

    any? do |time_slot|
      (start_at..end_at).cover?(time_slot.start_at)||
        (start_at..end_at).cover?(time_slot.end_at)
    end
  end
end
