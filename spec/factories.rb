FactoryGirl.define do
  factory :master_film do
    today = Time.zone.today
    sequence(:serial) { |n| "E0101-#{'%02d' % n}"}
    tenant_code 'pi'

    factory :master_film_with_child do
      after(:create) do |master_film|
        FactoryGirl.create(:film, master_film: master_film, serial: "#{master_film.serial}-1")
      end
    end
  end
    sequence(:serial) { |n| "E0101-#{'%02d' % n}"}

  factory :film do
    sequence(:serial) { |n| "F0101-#{'%02d' % n}-1"}
    phase "lamination"
    before(:create) do |film|
      film.master_film = FactoryGirl.create(:master_film, serial: film.serial[0..7]) unless film.master_film.present?
    end
    after(:create) do |film|
      FactoryGirl.create(:dimension, film: film)
    end
    tenant_code 'pi'
  end

  factory :dimension do
    width 60
    length 100
    film
  end

  factory :sales_order do
    sequence(:code) { |n| "PT#{ '%03d' % n }P" }
    tenant_code 'pi'

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
    tenant_code 'pi'

    factory :chemist do
      chemist true
    end

    factory :operator do
      operator true
    end

    factory :admin do
      role_level 1
    end
  end

  factory :machine do
    sequence(:code) { |n| "#{n}" }
    yield_constant 0.4
    tenant_code 'pi'
  end

  factory :film_movement do
    from_phase "lamination"
    to_phase "inspection"
    width 60
    length 100
    actor "Person"
    tenant_code 'pi'
    film
  end
end 
