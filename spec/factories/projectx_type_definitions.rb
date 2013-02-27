# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :type_definition, :class => 'Projectx::TypeDefinition' do
    name "MyString type"
    brief_note "MyString note"
    last_updated_by_id 1
    for_what "project"
    ranking_order 1
    active true
  end
end
