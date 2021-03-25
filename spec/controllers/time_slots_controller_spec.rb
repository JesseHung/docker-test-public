require 'rails_helper'

RSpec.describe TimeSlotsController, type: :request do 
  before do 
    @user = create(:user)
    @timeslot = create(:time_slot, user_id: @user.id)
  end

  after do 
    DatabaseCleaner.clean
  end

  describe "#index" do 
    it 'returns time-slots of the user' do
      get "/users/#{@user.id}/time-slots"
      resp = JSON.parse(response.body)
      expect(resp.size).to eq 1
      expect(resp[0]["id"]).to eq @timeslot.id
      expect(resp[0]["start_at"]).to eq @timeslot.start_at.to_i
      expect(resp[0]["end_at"]).to eq @timeslot.end_at.to_i
    end

    it 'returns filtered time-slots of the user' do 
      params = {
        before_timestamp: (Time.now - 3.day).to_i,
        after_timestamp: (Time.now - 2.day).to_i,
      }

      get "/users/#{@user.id}/time-slots", params: params
      resp = JSON.parse(response.body)
      expect(resp.size).to eq 0
    end

    it 'returns error if no user selected' do 
      get "/users/0/time-slots"
      resp = JSON.parse(response.body)
      expect(resp['success']).to be_falsey
    end
  end

  describe '#create' do 
    it 'returns created timeslot' do 
      params = {
        start_at: (Time.now + 4.hour).to_i,
        end_at: (Time.now + 10.hour).to_i,
      }
      post "/users/#{@user.id}/time-slots", params: params
      @last_timeslot = TimeSlot.last
      resp = JSON.parse(response.body)
      expect(resp["id"]).to eq @last_timeslot.id
      expect(resp["start_at"]).to eq @last_timeslot.start_at
      expect(resp["end_at"]).to eq @last_timeslot.end_at
    end

    it 'raise error if start_at is before now' do 
      params = {
        start_at: (Time.now - 2.hour).to_i,
        end_at: (Time.now + 4.hour).to_i,
      }

      post "/users/#{@user.id}/time-slots", params: params
      resp = JSON.parse(response.body)
      expect(resp['success']).to be_falsey
    end

    it 'raise error if end_at is before start_at' do 
      params = {
        start_at: (Time.now + 2.hour).to_i,
        end_at: Time.now.to_i,
      }

      post "/users/#{@user.id}/time-slots", params: params
      resp = JSON.parse(response.body)
      expect(resp['success']).to be_falsey
    end

    it 'raise error if end_at - start_at is more than 24.hours' do 
      params = {
        start_at: (Time.now + 2.hour).to_i,
        end_at: (Time.now + 3.day).to_i,
      }

      post "/users/#{@user.id}/time-slots", params: params
      resp = JSON.parse(response.body)
      expect(resp['success']).to be_falsey
    end

    it 'raise error if start_at/end_at has overlap with existing timeslot' do 
      params = {
        start_at: Time.now.to_i,
        end_at: (Time.now + 1.hour).to_i,
      }

      post "/users/#{@user.id}/time-slots", params: params
      resp = JSON.parse(response.body)
      expect(resp["success"]).to be_falsey
    end
  end

  describe '#delete' do 
    it 'deletes timeslot' do 
      delete "/users/#{@user.id}/time-slots/#{@timeslot.id}"
      get "/users/#{@user.id}/time-slots"
      resp = JSON.parse(response.body)
      expect(resp.size).to eq 0
    end

    it 'returns error' do 
      delete "/users/#{@user.id}/time-slots/#{TimeSlot.all.size  + 1}"
      resp = JSON.parse(response.body)
      expect(resp['success']).to be_falsey
    end
  end
end