# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status_definition, :class => 'Projectx::StatusDefinition' do
    name "MyString status"
    brief_note "MyString some note"
    last_updated_by_id 1
    for_what "task"
    ranking_order 1
    active true
  end
end
