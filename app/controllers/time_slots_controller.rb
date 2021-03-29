class TimeSlotsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, except: [:destroy]
  before_action :set_timeslot, only: [:destroy]

  def index
    timeslots = @user.time_slots
    timeslots = timeslots.where('end_at > ?', params[:before_timestamp]) if params[:before_timestamp].present?
    timeslots = timeslots.where('end_at < ?', params[:after_timestamp]) if params[:after_timestamp].present?
    timeslots = timeslots.order(start_at: :asc)

    render json: timeslots.as_json(only: [:id, :start_at, :end_at])
  end

  def create
    if params[:start_at].to_i < Time.now.to_i
      raise "Start_at must be greater than now."
    end

    if params[:start_at].to_i > params[:end_at].to_i
      raise "End_at must greater than start_at."
    end

    if (params[:end_at].to_i - params[:start_at].to_i) / 60 / 60 > 24
      raise "End_at - start_at must less than or equal 24 hours"
    end

    if @user.time_slots.has_overlap?(start_at: params[:start_at], end_at: params[:end_at])
      raise "Timeslots from the same user are not allowed to overlap"
    end

    ActiveRecord::Base.transaction do 
      @timeslot = @user.time_slots.create!(
        start_at: params[:start_at],
        end_at: params[:end_at],
      )
    end

    render json: @timeslot.as_json(
      only: [
        :id, :start_at, :end_at,
      ]
    )

  rescue => e
    render json: { success: false, message: e.message }
  end

  def destroy
    ActiveRecord::Base.transaction do 
      @timeslot.destroy!
    end

    render json: { success: true }

  rescue => e
    render json: { success: false, message: e.message }
  end

  private

  def set_user
    @user = User.includes(:time_slots).find(params[:user_id])
  rescue => e
    render json: { success: false, message: e.message }
  end

  def set_timeslot
    @timeslot = TimeSlot.find(params[:id])
  rescue => e
    render json: { success: false, message: e.message }
  end
end
