FactoryBot.define do
  factory :quiz do
    title        { FFaker::Lorem.word }
    association :evaluator, factory: :user
    association :evaluated, factory: :user
    association :user, factory: :user
    proactivity  {rand(0..10)}
    organization {rand(0..10)}
    flexibility  {rand(0..10)}
    efficiency   {rand(0..10)}
    team_work    {rand(0..10)}
  end
end