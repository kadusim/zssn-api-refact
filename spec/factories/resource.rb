FactoryBot.define do
  factory :resource_ do
      item :empty
      value 0

    factory :resource_water do
      item :water
      value 4
    end

    factory :resource_food do
      item :food
      value 3
    end

    factory :resource_medication do
      item :medication
      value 2
    end

    factory :resource_ammunition do
      item :ammunition
      value 1
    end
    
  end
end
