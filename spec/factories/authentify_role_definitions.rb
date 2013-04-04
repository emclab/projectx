# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role_definition, :class => 'Authentify::RoleDefinition' do
    name "sales"
    brief_note "role sales"
    last_updated_by_id 1
  end
end
