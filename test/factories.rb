FactoryGirl.define do
  factory :master_film do
    sequence(:serial) { |n| "E#{'%04d' % n }-#{'%02d' % n}"}
  end

  factory :film do
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
