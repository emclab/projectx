# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_task_template, :class => 'Projectx::ProjectTaskTemplate' do
    name "MyString"
    type_definition_id 1
    last_updated_by_id 1
    active true
    instruction "MyText"
  end
end
