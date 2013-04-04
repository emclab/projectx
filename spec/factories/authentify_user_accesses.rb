# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_access, :class => 'Authentify::UserAccess' do
    right "allow"
    role_definition_id 1
    action "index"
    resource "Customerx::Customers"
    resource_type "table"
  end
end
