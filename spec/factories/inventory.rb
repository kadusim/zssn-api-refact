FactoryBot.define do
  factory :inventory do
    survivor

    factory :inventory_with_resources, parent: :inventory do
      resources { [
        create(:resource_water),
        create(:resource_food),
        create(:resource_medication),
        create(:resource_ammunition)
        ] }
    end
    # let!(:inventory_with_resources) { create(:inventory_with_resources) }

    factory :inventory_with, parent: :inventory do
      transient do
        resource_count 1
        resource_item ''
      end
      resources { create_list "resource_#{resource_item}", resource_count }
    end
    # let!(:inventory_with_food) { create(:inventory_with, resource_count: 4, resource_item: :food) }
    
  end
end
