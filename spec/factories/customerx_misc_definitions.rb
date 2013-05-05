# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customerx_misc_definition, :class => 'Customerx::MiscDefinition' do
    name "MyString"
    brief_note "MyText"
    #active true
    ranking_order 1
    last_updated_by_id 1
    for_which "My which"
  end
end
