FactoryGirl.define do
  factory :master_film do
    sequence(:date_code) { |n| "E#{'%04d' % n }"}
    sequence(:number) { |n| n } 
    formula "AB"
    mix_mass 101.5
    film_code "ABCD"
    thinky_code "1"
    machine
    association :chemist
    association :operator
  end

  factory :film do
    # automatically set
    # division 2
    phase "lamination"
    master_film
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "Example Person #{n}" }

    factory :chemist do
      chemist true
    end

    factory :operator do
      operator true
    end
  end

  factory :machine do
    sequence(:code) { |n| "#{n}" }
  end

  factory :defect do
    defect_type "white spot"
    count 2
    master_film
  end
end 
