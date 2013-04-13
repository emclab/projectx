# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_template, :class => 'Projectx::ProjectTemplate' do
    name "MyString"
    project_type_id 1
    last_updated_by_id 1
    active true
    instruction "MyText"
  end
end
