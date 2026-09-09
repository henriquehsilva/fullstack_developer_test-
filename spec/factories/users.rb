FactoryBot.define do
  factory :user do
    sequence(:full_name) { |number| "Test User #{number}" }
    sequence(:email) { |number| "user#{number}@example.com" }
    password { "SecurePass123!" }
    role { :user }

    trait :admin do
      role { :admin }
    end
  end
end
