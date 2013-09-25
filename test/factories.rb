FactoryGirl.define do
  factory :master_film do
    today = Date.today
    sequence(:serial) { |n| "E#{ today.strftime('%m') + today.strftime('%d') }-#{ ('%02d' % n)[-2, 2] }"}
  end

  factory :film do
    phase "lamination"
    master_film
  end

  factory :film_movement do
    from "stock"
    to "wip"
    film
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
    yield_constant 0.4
  end

  factory :defect do
    defect_type "White Spot"
    count 2
    master_film
  end
end 
