ActiveRecord::Base.transaction do 
  User.find_or_create_by(
    name: "Jessie"
  )
end