# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :skip_task_for_project, :class => 'Projectx::SkipTaskForProject' do
    project_id 1
    task_definition_id 1
  end
end
