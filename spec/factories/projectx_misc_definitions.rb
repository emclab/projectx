# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :misc_definition, :class => 'Projectx::MiscDefinition' do
    name "misc definition"
    active true
    for_which "MyString"
    brief_note "MyText"
    last_updated_by_id 1
    ranking_order 1
  end
end
