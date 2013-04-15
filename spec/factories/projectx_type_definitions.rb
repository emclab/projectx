# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :type_definition, :class => 'Projectx::TypeDefinition' do
    name "MyString"
    active true
    brief_note "MyText"
    last_updated_by_id 1
    ranking_order 1
  end
end
