# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes [:id , :phone, :first_name, :gender, :verified,
    :display_city, :display_state, :age,
    :occupation, :created_at, :premium]

  def age
    now = Time.now.utc.to_date
    dob = object.birthday.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end