FactoryBot.define do
  factory :user do
    name         { FFaker::Lorem.word }
    email        { FFaker::Internet.email }
    last_name    { FFaker::Lorem.word }
    password     'secret123'

    factory :admin do
      after(:create) do |user|
        user.remove_role :employe
        user.add_role :admin
      end
    end
  end

  factory :user_relation do
    association :user, factory: :user
    association :user2, factory: :user
  end
end