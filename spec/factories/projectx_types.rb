# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :type, :class => 'Projectx::Type' do
    name "MyString"
    brief_note "MyString"
    last_updated_by_id 1
    for_what "MyString"
  end
end
