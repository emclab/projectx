# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :log, :class => 'Projectx::Log' do
    content "MyString"
    last_updated_by_id 1
    for_what "MyString"
  end
end
