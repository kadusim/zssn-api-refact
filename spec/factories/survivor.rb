FactoryBot.define do
  factory :survivor do

    name      { Faker::Lorem.word }
    age       { Faker::Number.number(3) }
    gender    %i[M F U].sample
    latitude  { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    infected  false

    factory :survivor_with_resources do
      after(:create) do |survivor|
        create(:inventory_with_resources, survivor: survivor)
      end
    end

    factory :survivor_without_resources do
      after(:create) do |survivor|
        create(:inventory, survivor: survivor)
      end
    end

    factory :survivor_infected_without_resources do
      infected true
      after(:create) do |survivor|
        create(:inventory, survivor: survivor)
      end
    end
    
    factory :survivor_infected do
      infected true
    end

  end
end
