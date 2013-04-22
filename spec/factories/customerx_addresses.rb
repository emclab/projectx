# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address, :class => 'Customerx::Address' do
    province "my prov"
    city_county_district "city county"
    add_line "123 road"
    customer_id 1
  end
end
