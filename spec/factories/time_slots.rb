FactoryBot.define do 
  factory :time_slot do
    start_at { Time.now.to_i }
    end_at { (Time.now + 3.hour).to_i }
  end
end