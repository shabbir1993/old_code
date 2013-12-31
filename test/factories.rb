FactoryGirl.define do
  factory :master_film do
    today = Time.zone.today
    sequence(:serial) { |n| "E0101-#{'%02d' % n}"}
    tenant

    factory :master_film_with_child do
      after(:create) do |master_film|
        FactoryGirl.create(:film, master_film: master_film, 
                                  tenant: master_film.tenant)
      end
    end
  end

  factory :film do
    phase "lamination"
    tenant
    after(:build) do |film|
      film.master_film = FactoryGirl.create(:master_film, tenant: film.tenant) unless film.master_film.present?
    end

    factory :film_with_dimensions do
      width 60
      length 100
    end
  end

  factory :sales_order do
    sequence(:code) { |n| "PT#{ '%03d' % n }P" }
    tenant

    factory :sales_order_with_line_item do
      after(:create) do |sales_order|
        FactoryGirl.create(:line_item, sales_order: sales_order)
      end
    end
  end

  factory :line_item do
    custom_width 55
    custom_length 80
    quantity 2
    sales_order
  end

  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:full_name) { |n| "Example Person #{n}" }
    password "foobar"
    password_confirmation "foobar"
    tenant

    factory :chemist do
      chemist true
    end

    factory :operator do
      operator true
    end

    factory :supervisor do
      role_level 1
    end

    factory :admin do
      role_level 2
    end
  end

  factory :machine do
    sequence(:code) { |n| "#{n}" }
    yield_constant 0.4
    tenant
  end

  factory :defect do
    defect_type "White Spot"
    count 2
    master_film
  end

  factory :tenant do
    sequence(:name) { |n| "Tenant #{n}"}
  end
end 
