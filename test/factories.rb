FactoryGirl.define do
  sequence :email do |n| 
    "email#{n}@gmail.com"
  end
  
  factory :account do
    sequence(:email) {|n| "fankai#{n}@gmail.com"}
    password 'javaeye'
    password_confirmation 'javaeye'
    role 'admin'
  end
end